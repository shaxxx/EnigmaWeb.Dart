import 'dart:async';

import 'package:dio/dio.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/responses/i_binary_response.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';

abstract class IWebRequester {
  Future<IBinaryResponse> getBinaryResponseAsync(String url, IProfile profile, {CancelToken cancelToken});

  Future<IStringResponse> getResponseAsync(String url, IProfile profile, {CancelToken cancelToken});
}
