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
    this.proxy = null,
  }) : assert(log != null) {
    _cookies = CookieManager(CookieJar());
  }

  @override
  Future<IBinaryResponse> getBinaryResponseAsync(String url, IProfile profile, {CancelToken cancelToken}) async {
    var responseWithDuration = await _getResponse(url, profile, ResponseType.bytes, cancelToken: cancelToken);
    return BinaryResponse(responseWithDuration.httpResponse.data, responseWithDuration.duration);
  }

  @override
  Future<IStringResponse> getResponseAsync(String url, IProfile profile, {CancelToken cancelToken}) async {
    var responseWithDuration = await _getResponse(url, profile, ResponseType.plain, cancelToken: cancelToken);
    return StringResponse(responseWithDuration.httpResponse.toString(), responseWithDuration.duration);
  }

  String _contentTypeByEnigmaVersion(EnigmaType enigma) {
    return enigma == EnigmaType.enigma1 ? "text/html" : "text/xml";
  }

  Dio _createHttpClient(ResponseType responseType, IProfile profile) {
    Dio dio = Dio();
    dio.options.connectTimeout = connectTimeOut;
    dio.options.receiveTimeout = receiveTimeOut;
    dio.options.responseType = responseType;
    _setBasicAuthHeader(dio, profile);
    _setXRequesteWithHeader(dio);
    _setUserAgentHeader(dio);
    dio.options.contentType = ContentType.parse(_contentTypeByEnigmaVersion(profile.enigma));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      _setHttpProxy(client);
      _setHttpCertificateValidaton(client);
    };
    dio.interceptors.add(_cookies);
    return dio;
  }

  String _createUrl(String url, IProfile profile) {
    var addressWithoutHttpPrefix = "${profile.address}:${profile.httpPort}/$url";
    if (profile.useSsl) {
      return "https://" + addressWithoutHttpPrefix;
    } else {
      return "http://" + addressWithoutHttpPrefix;
    }
  }

  String _getBasicAuthHeader(String username, String password) {
    return 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  }

  Future<_ResponseWithDuration> _getResponse(String url, IProfile profile, ResponseType responseType,
      {CancelToken cancelToken, bool authorize = false}) async {
    var completeUrl = _createUrl(url, profile);
    log.fine("Initializing request to $url");
    Response response;
    var st = Stopwatch();
    try {
      var httpClient = _createHttpClient(responseType, profile);
      st.start();
      response = await httpClient.get(completeUrl, cancelToken: cancelToken);
      st.stop();
      _throwIfCanceled(cancelToken, url);
      log.fine("Request for $url took ${st.elapsedMilliseconds} ms");
      logResponse(response, url, responseType);
    } on DioError catch (e) {
      if (e.type == DioErrorType.CANCEL) {
        throw OperationCanceledException.withException(e.message, e);
      } else if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        throw TimeOutException.withException(e.message, url, Duration(milliseconds: e.request.connectTimeout), e);
      } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
        throw TimeOutException.withException(e.message, url, Duration(milliseconds: e.request.receiveTimeout), e);
      } else if (e.type == DioErrorType.SEND_TIMEOUT) {
        throw TimeOutException.withException(e.message, url, Duration(milliseconds: e.request.sendTimeout), e);
      }
      if (e.response != null) {
        throw FailedStatusCodeException(e.message, response.statusCode as HttpStatus);
      }
      throw WebRequestException.withException(e.message, e);
    } on Exception catch (e) {
      if (e is KnownException) rethrow;
      if (e is Exception) {
        throw WebRequestException.withException("Request for $completeUrl failed.", e);
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
      if (responseType == ResponseType.json || responseType == ResponseType.plain) {
        log.finest("$url response is");
        log.finest(response.toString());
      } else if (responseType == ResponseType.bytes) {
        log.finest("$url response content length is ${response.headers.contentLength} bytes.");
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
        'Authorization': _getBasicAuthHeader(profile.username, profile.password),
      });
    }
  }

  void _setHttpCertificateValidaton(HttpClient client) {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
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

  void _throwIfCanceled(CancelToken cancelToken, String url) {
    if (cancelToken != null) {
      if (cancelToken.isCancelled) {
        throw OperationCanceledException("Request for $url was canceled.");
      }
    }
  }
}

class _ResponseWithDuration {
  final Response httpResponse;
  final Duration duration;
  _ResponseWithDuration(this.httpResponse, this.duration);
}
