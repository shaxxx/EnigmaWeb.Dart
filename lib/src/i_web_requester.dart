import 'dart:async';

import 'package:dio/dio.dart';

import 'i_profile.dart';

abstract class IWebRequester {
  Future<String> getResponseAsync(String url, IProfile profile, {CancelToken cancelToken});

  Future<List<int>> getBinaryResponseAsync(String url, IProfile profile, {CancelToken cancelToken});
}
