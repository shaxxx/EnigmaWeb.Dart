import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'enums.dart';
import 'i_profile.dart';
import 'i_web_requester.dart';
import 'known_exception.dart';
import 'operation_cancelled_exception.dart';
import 'string_helper.dart';
import 'web_request_exception.dart';

class WebRequester implements IWebRequester {
  CookieManager _cookies;
  int connectTimeOut;
  int receiveTimeOut;
  String userAgentHeader;
  String xRequestedWithHeader;
  Logger _log;

  WebRequester(Logger log) {
    if (log == null) {
      throw ArgumentError.notNull("log");
    }
    _log = log;
    _cookies = CookieManager(CookieJar());
    this.connectTimeOut = 15000;
    this.receiveTimeOut = 60000;
    this.userAgentHeader =
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36";
    this.xRequestedWithHeader = 'XMLHttpRequest';
  }

  @override
  Future<List<int>> getBinaryResponseAsync(String url, IProfile profile,
      {CancelToken cancelToken}) async {
    var response = await _getResponse(url, profile, ResponseType.bytes, cancelToken: cancelToken);
    return response.data;
  }

  @override
  Future<String> getResponseAsync(String url, IProfile profile, {CancelToken cancelToken}) async {
    var response = await _getResponse(url, profile, ResponseType.plain, cancelToken: cancelToken);
    return response.toString();
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
      //_setHttpFiddlerProxy(client);
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

  Future<Response> _getResponse(String url, IProfile profile, ResponseType responseType,
      {CancelToken cancelToken, bool authorize = false}) async {
    var completeUrl = _createUrl(url, profile);
    _log.fine("Initializing request to $url");
    Response response;
    try {
      var httpClient = _createHttpClient(responseType, profile);
      var st = Stopwatch();
      st.start();
      response = await httpClient.get(completeUrl, cancelToken: cancelToken);
      st.stop();
      _throwIfCanceled(cancelToken, url);
      _log.fine("Request for $url took ${st.elapsedMilliseconds} ms");
      _logResponse(response, url, responseType);
    } on DioError catch (e) {
      if (e.type == DioErrorType.CANCEL) {
        throw OperationCanceledException.withException(e.message, e);
      }
      throw WebRequestException.withException(e.message, e);
    } on Exception catch (e) {
      if (e is KnownException) rethrow;
      if (e is Exception)
        throw WebRequestException.withException("Request for $completeUrl failed.", e);
    }
    return response;
  }

  void _logResponse(Response response, String url, ResponseType responseType) {
    if (response == null) {
      {
        _log.warning("Response to $url is null!");
      }
    } else {
      if (responseType == ResponseType.json || responseType == ResponseType.plain) {
        _log.finest("$url response is");
        _log.finest(response.toString());
      } else if (responseType == ResponseType.bytes) {
        _log.finest("$url response content length is ${response.headers.contentLength} bytes.");
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
      if (dio.options.headers == null) dio.options.headers = {};
      dio.options.headers.addAll({
        'Authorization': _getBasicAuthHeader(profile.username, profile.password),
      });
    }
  }

  void _setHttpCertificateValidaton(HttpClient client) {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }

  // void _setHttpFiddlerProxy(HttpClient client) {
  //   client.findProxy = (uri) {
  //     return "PROXY localhost:8888";
  //   };
  // }

  void _setUserAgentHeader(Dio dio) {
    if (StringHelper.stringIsNullOrEmpty(userAgentHeader)) return;
    if (dio.options.headers == null) dio.options.headers = {};
    dio.options.headers.addAll({'User-Agent': userAgentHeader});
  }

  void _setXRequesteWithHeader(Dio dio) {
    if (StringHelper.stringIsNullOrEmpty(xRequestedWithHeader)) return;
    if (dio.options.headers == null) dio.options.headers = {};
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
