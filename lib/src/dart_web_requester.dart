import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:cookie_jar/cookie_jar.dart';

import 'package:enigma_web/enigma_web.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/i_web_requester.dart';
import 'package:enigma_web/src/known_exception.dart';
import 'package:enigma_web/src/operation_cancelled_exception.dart';
import 'package:enigma_web/src/responses/binary_response.dart';
import 'package:enigma_web/src/responses/i_binary_response.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';
import 'package:enigma_web/src/responses/string_response.dart';
import 'package:enigma_web/src/string_helper.dart';
import 'package:enigma_web/src/web_request_exception.dart';
import 'package:logging/logging.dart';

enum HttpResponseType {
  plain,
  bytes,
  json,
}
enum _HttpClientErrorType {
  CONNECT_TIMEOUT,
  RECEIVE_TIMEOUT,
  RESPONSE,
  DEFAULT
}

/// DioError describes the error info  when request failed.
class HttpClientError implements Exception {
  HttpClientError({
    this.message,
    this.type = _HttpClientErrorType.DEFAULT,
    this.error,
    this.stackTrace,
    this.statusCode,
  });

  /// Error descriptions.
  String message;
  _HttpClientErrorType type;
  int statusCode;

  /// The original error/exception object; It's usually not null when `type`
  /// is DioErrorType.DEFAULT
  dynamic error;

  String toString() =>
      "HttpClientError [$type]: " +
      (message ?? "") +
      (stackTrace ?? "").toString();

  /// Error stacktrace info
  StackTrace stackTrace;
}

class DartWebRequester implements IWebRequester {
  final CookieJar _cookies;
  final String xRequestedWithHeader;
  final String proxy;
  final Logger log;
  final HttpClient client;

  DartWebRequester(
    this.client,
    this.log, {
    this.xRequestedWithHeader = "XMLHttpRequest",
    this.proxy,
  })  : _cookies = CookieJar(),
        assert(log != null) {}

  @override
  Future<IBinaryResponse> getBinaryResponseAsync(
    String url,
    IProfile profile,
  ) async {
    var responseWithDuration = await _getResponse(
      url,
      profile,
      HttpResponseType.bytes,
    );
    return BinaryResponse(
        responseWithDuration.httpResponse, responseWithDuration.duration);
  }

  @override
  Future<IStringResponse> getResponseAsync(
    String url,
    IProfile profile,
  ) async {
    var responseWithDuration = await _getResponse(
      url,
      profile,
      HttpResponseType.plain,
    );
    return StringResponse(
        responseWithDuration.httpResponse, responseWithDuration.duration);
  }

  static String _contentTypeByEnigmaVersion(EnigmaType enigma) {
    return enigma == EnigmaType.enigma1 ? "text/html" : "text/xml";
  }

  static HttpClient createHttpClient({
    Duration connectTimeOut = const Duration(seconds: 15),
    String userAgentHeader =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36',
    String proxy,
  }) {
    var client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    client.connectionTimeout = connectTimeOut;
    _setUserAgentHeader(client, userAgentHeader);
    _setHttpCertificateValidaton(client);
    _setHttpProxy(client, proxy);
    return client;
  }

  static String _createUrl(String url, IProfile profile) {
    var addressWithoutHttpPrefix =
        "${profile.address}:${profile.httpPort}/$url";
    if (profile.useSsl) {
      return "https://" + addressWithoutHttpPrefix;
    } else {
      return "http://" + addressWithoutHttpPrefix;
    }
  }

  static String _getBasicAuthHeader(String username, String password) {
    return 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  }

  Future<_ResponseWithDuration> _getResponse(
      String url, IProfile profile, HttpResponseType responseType,
      {bool authorize = false}) async {
    var completeUrl = _createUrl(url, profile);
    log.fine("Initializing request to $url");
    var uri = Uri.parse(completeUrl);
    var st = Stopwatch();
    dynamic response;
    try {
      st.start();
      HttpClientRequest clientRequest;
      try {
        clientRequest = await client.getUrl(uri);
      } on TimeoutException {
        throw HttpClientError(
          message: "Connecting timeout[${client.connectionTimeout}ms]",
          type: _HttpClientErrorType.CONNECT_TIMEOUT,
        );
      }
      _setBasicAuthHeader(clientRequest, profile);
      _setXRequestedWithHeader(clientRequest, xRequestedWithHeader);
      _setContentTypeHeader(clientRequest, profile);
      clientRequest.cookies.addAll(_cookies.loadForRequest(uri));
      HttpClientResponse clientResponse;
      try {
        clientResponse = await clientRequest.close();
        if (clientResponse.statusCode >= 400) {
          throw HttpClientError(
            message: "Status code [${clientResponse.statusCode}]",
            type: _HttpClientErrorType.RESPONSE,
            statusCode: clientResponse.statusCode,
          );
        }
        if (responseType == HttpResponseType.bytes) {
          response = (await clientResponse.toList()).single;
        } else {
          response = (await utf8.decoder.bind(clientResponse).toList()).single;
        }
      } on TimeoutException {
        throw HttpClientError(
          message: "Receive timeout[${client.connectionTimeout}ms]",
          type: _HttpClientErrorType.RECEIVE_TIMEOUT,
        );
      }

      st.stop();
      log.fine("Request for $url took ${st.elapsedMilliseconds} ms");
      logResponse(response, url, responseType);
      _cookies.saveFromResponse(uri, clientResponse.cookies);
    } on HttpClientError catch (e) {
      if (e.type == _HttpClientErrorType.CONNECT_TIMEOUT) {
        throw TimeOutException(
          e.message,
          url,
          client.connectionTimeout,
          innerException: e,
        );
      } else if (e.type == _HttpClientErrorType.RESPONSE) {
        throw FailedStatusCodeException(
          e.message,
          e.statusCode,
          innerException: e,
        );
      }
      throw WebRequestException(e.message, innerException: e);
    } on Exception catch (e) {
      if (e is KnownException) rethrow;
      if (e is Exception) {
        throw WebRequestException("Request for $completeUrl failed.",
            innerException: e);
      }
    }
    return _ResponseWithDuration(response, st.elapsed);
  }

  void logResponse(
      dynamic response, String url, HttpResponseType responseType) {
    if (response == null) {
      {
        log.warning("Response to $url is null!");
      }
    } else {
      if (responseType == HttpResponseType.json ||
          responseType == HttpResponseType.plain) {
        log.finest("$url response is");
        log.finest(response.toString());
      } else if (responseType == HttpResponseType.bytes) {
        log.finest(
            "$url response content length is ${response.headers.contentLength} bytes.");
      }
    }
  }

  static bool _profileHasValidCredentials(IProfile profile) {
    if (StringHelper.stringIsNullOrEmpty(profile.username)) return false;
    if (StringHelper.stringIsNullOrEmpty(profile.password)) return false;
    return true;
  }

  static void _setBasicAuthHeader(HttpClientRequest request, IProfile profile) {
    if (_profileHasValidCredentials(profile)) {
      request.headers.add(
        'Authorization',
        _getBasicAuthHeader(profile.username, profile.password),
      );
    }
  }

  static void _setHttpCertificateValidaton(HttpClient client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  }

  static void _setHttpProxy(HttpClient client, String proxy) {
    if (proxy != null) {
      client.findProxy = (uri) {
        return "PROXY " + proxy;
      };
    }
  }

  static void _setUserAgentHeader(HttpClient client, String userAgentHeader) {
    if (StringHelper.stringIsNullOrEmpty(userAgentHeader)) return;
    client.userAgent = userAgentHeader;
  }

  static void _setXRequestedWithHeader(
      HttpClientRequest request, String xRequestedWithHeader) {
    if (StringHelper.stringIsNullOrEmpty(xRequestedWithHeader)) return;
    request.headers.add('X-Requested-With', xRequestedWithHeader);
  }

  static void _setContentTypeHeader(
    HttpClientRequest request,
    IProfile profile,
  ) {
    request.headers
        .add('Content-Type', _contentTypeByEnigmaVersion(profile.enigma));
  }
}

class _ResponseWithDuration {
  final dynamic httpResponse;
  final Duration duration;
  _ResponseWithDuration(this.httpResponse, this.duration);
}
