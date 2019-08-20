import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
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

class WebRequester implements IWebRequester {
  CookieManager _cookies;
  final int connectTimeOut;
  final int receiveTimeOut;
  final String userAgentHeader;
  final String xRequestedWithHeader;
  final String proxy;
  final Logger log;

  WebRequester(
    this.log, {
    this.connectTimeOut = 15000,
    this.receiveTimeOut = 60000,
    this.userAgentHeader =
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36",
    this.xRequestedWithHeader = "XMLHttpRequest",
    this.proxy,
  }) : assert(log != null) {
    _cookies = CookieManager(CookieJar());
  }

  @override
  Future<IBinaryResponse> getBinaryResponseAsync(
    String url,
    IProfile profile,
  ) async {
    var responseWithDuration = await _getResponse(
      url,
      profile,
      ResponseType.bytes,
    );
    return BinaryResponse(
        responseWithDuration.httpResponse.data, responseWithDuration.duration);
  }

  @override
  Future<IStringResponse> getResponseAsync(String url, IProfile profile) async {
    var responseWithDuration = await _getResponse(
      url,
      profile,
      ResponseType.plain,
    );
    return StringResponse(responseWithDuration.httpResponse.toString(),
        responseWithDuration.duration);
  }

  String _contentTypeByEnigmaVersion(EnigmaType enigma) {
    return enigma == EnigmaType.enigma1 ? "text/html" : "text/xml";
  }

  Dio _createHttpClient(IProfile profile) {
    Dio dio = Dio();
    dio.options.connectTimeout = connectTimeOut;
    dio.options.receiveTimeout = receiveTimeOut;
    _setBasicAuthHeader(dio, profile);
    _setXRequesteWithHeader(dio);
    _setUserAgentHeader(dio);
    dio.options.contentType =
        ContentType.parse(_contentTypeByEnigmaVersion(profile.enigma));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      _setHttpProxy(client);
      _setHttpCertificateValidaton(client);
    };
    dio.interceptors.add(_cookies);
    return dio;
  }

  void _setResponseType(Dio dio, ResponseType responseType) {
    dio.options.responseType = responseType;
  }

  String _createUrl(String url, IProfile profile) {
    var addressWithoutHttpPrefix =
        "${profile.address}:${profile.httpPort}/$url";
    if (profile.useSsl) {
      return "https://" + addressWithoutHttpPrefix;
    } else {
      return "http://" + addressWithoutHttpPrefix;
    }
  }

  String _getBasicAuthHeader(String username, String password) {
    return 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  }

  Future<_ResponseWithDuration> _getResponse(
      String url, IProfile profile, ResponseType responseType,
      {bool authorize = false}) async {
    var completeUrl = _createUrl(url, profile);
    log.fine("Initializing request to $url");
    Response response;
    var st = Stopwatch();
    try {
      var client = _createHttpClient(profile);
      _setResponseType(client, responseType);
      st.start();
      response = await client.get(completeUrl);
      st.stop();
      log.fine("Request for $url took ${st.elapsedMilliseconds} ms");
      logResponse(response, url, responseType);
    } on DioError catch (e) {
      if (e.type == DioErrorType.CANCEL) {
        throw OperationCanceledException(e.message, innerException: e);
      } else if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        throw TimeOutException(
          e.message,
          url,
          Duration(milliseconds: e.request.connectTimeout),
          innerException: e,
        );
      } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
        throw TimeOutException(
          e.message,
          url,
          Duration(milliseconds: e.request.receiveTimeout),
          innerException: e,
        );
      } else if (e.type == DioErrorType.SEND_TIMEOUT) {
        throw TimeOutException(
          e.message,
          url,
          Duration(milliseconds: e.request.sendTimeout),
          innerException: e,
        );
      } else if (e.type == DioErrorType.RESPONSE) {
        throw FailedStatusCodeException(
          e.message,
          e.response.statusCode,
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

  void logResponse(Response response, String url, ResponseType responseType) {
    if (response == null) {
      {
        log.warning("Response to $url is null!");
      }
    } else {
      if (responseType == ResponseType.json ||
          responseType == ResponseType.plain) {
        log.finest("$url response is");
        log.finest(response.toString());
      } else if (responseType == ResponseType.bytes) {
        log.finest(
            "$url response content length is ${response.headers.contentLength} bytes.");
      }
    }
  }

  bool _profileHasValidCredentials(IProfile profile) {
    if (StringHelper.stringIsNullOrEmpty(profile.username)) return false;
    if (StringHelper.stringIsNullOrEmpty(profile.password)) return false;
    return true;
  }

  void _setBasicAuthHeader(dio, IProfile profile) {
    if (_profileHasValidCredentials(profile)) {
      if (dio.options.headers == null) {
        dio.options.headers = {};
      }
      ;
      dio.options.headers.addAll({
        'Authorization':
            _getBasicAuthHeader(profile.username, profile.password),
      });
    }
  }

  void _setHttpCertificateValidaton(HttpClient client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  }

  void _setHttpProxy(HttpClient client) {
    if (proxy != null) {
      client.findProxy = (uri) {
        return "PROXY " + proxy;
      };
    }
  }

  void _setUserAgentHeader(Dio dio) {
    if (StringHelper.stringIsNullOrEmpty(userAgentHeader)) return;
    if (dio.options.headers == null) {
      dio.options.headers = {};
    }
    dio.options.headers.addAll({'User-Agent': userAgentHeader});
  }

  void _setXRequesteWithHeader(Dio dio) {
    if (StringHelper.stringIsNullOrEmpty(xRequestedWithHeader)) return;
    if (dio.options.headers == null) {
      dio.options.headers = {};
    }
    dio.options.headers.addAll({'X-Requested-With': xRequestedWithHeader});
  }
}

class _ResponseWithDuration {
  final Response httpResponse;
  final Duration duration;
  _ResponseWithDuration(this.httpResponse, this.duration);
}
