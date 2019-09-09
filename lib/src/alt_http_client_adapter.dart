import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:alt_http/alt_http.dart';

/// The default HttpClientAdapter for Dio is [DefaultHttpClientAdapter].
class AltHttpClientAdapter extends HttpClientAdapter {
  Uint8List E;

  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>> requestStream,
    Future cancelFuture,
  ) async {
    var _httpClient = _configHttpClient(cancelFuture);

    Future requestFuture;
    if (options.connectTimeout > 0) {
      // Because there is a bug in [httpClient.connectionTimeout] now, we replace it
      // with `Future.timeout()` when it comes.
      // Bug issue: https://github.com/dart-lang/sdk/issues/34980.
      //_httpClient.connectionTimeout= Duration(milliseconds: options.connectTimeout);
//      _httpClient.connectionTimeout =
//          Duration(milliseconds: options.connectTimeout);
      requestFuture = _httpClient
          .openUrl(options.method, options.uri)
          .timeout(Duration(milliseconds: options.connectTimeout));
    } else {
      _httpClient.connectionTimeout = null;
      requestFuture = _httpClient.openUrl(options.method, options.uri);
    }

    HttpClientRequest request;
    try {
      request = await requestFuture;
      //Set Headers
      options.headers.forEach((k, v) => request.headers.set(k, v));
    } on TimeoutException {
      throw DioError(
        request: options,
        error: "Connecting timeout[${options.connectTimeout}ms]",
        type: DioErrorType.CONNECT_TIMEOUT,
      );
    }

    request.followRedirects = options.followRedirects;
    request.maxRedirects = options.maxRedirects;

    if (options.method != "GET" && requestStream != null) {
      // Transform the request data
      await request.addStream(requestStream);
    }
    Future future = request.close();
    if (options.receiveTimeout > 0) {
      future = future.timeout(Duration(milliseconds: options.receiveTimeout));
    }
    HttpClientResponse responseStream;
    try {
      responseStream = await future;
    } on TimeoutException {
      throw DioError(
        request: options,
        error: "Receiving data timeout[${options.receiveTimeout}ms]",
        type: DioErrorType.RECEIVE_TIMEOUT,
      );
    }

    // https://github.com/dart-lang/co19/issues/383
    Stream<Uint8List> stream =
        responseStream.transform(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(Uint8List.fromList(data));
      },
    ));

    return ResponseBody(
      stream,
      responseStream.statusCode,
      headers: responseStream.headers,
      redirects: responseStream.redirects,
      statusMessage: responseStream.reasonPhrase,
    );
  }

  HttpClient _configHttpClient(Future cancelFuture) {
    if (cancelFuture != null) {
      var _httpClient = AltHttpClient();
      if (onHttpClientCreate != null) {
        //user can return a HttpClient instance
        _httpClient = onHttpClientCreate(_httpClient) ?? _httpClient;
      }
      _httpClient.idleTimeout = Duration(seconds: 0);
      cancelFuture.whenComplete(() {
        Future.delayed(Duration(seconds: 0)).then((e) {
          try {
            _httpClient.close(force: true);
          } catch (e) {
            //...
          }
        });
      });
      return _httpClient;
    } else if (_defaultHttpClient == null) {
      _defaultHttpClient = AltHttpClient();
      _defaultHttpClient.idleTimeout = Duration(seconds: 3);
      if (onHttpClientCreate != null) {
        //user can return a HttpClient instance
        _defaultHttpClient =
            onHttpClientCreate(_defaultHttpClient) ?? _defaultHttpClient;
      }
    }
    return _defaultHttpClient;
  }

  /// [Dio] will create HttpClient when it is needed.
  /// If [onHttpClientCreate] is provided, [Dio] will call
  /// it when a HttpClient created.
  OnHttpClientCreate onHttpClientCreate;

  HttpClient _defaultHttpClient;
}
