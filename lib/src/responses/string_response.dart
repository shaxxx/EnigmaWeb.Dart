import 'package:enigma_web/src/responses/i_string_response.dart';

class StringResponse implements IStringResponse {
  final Duration _responseDuration;
  final String _responseString;

  StringResponse(this._responseString, this._responseDuration) {}

  @override
  Duration get responseDuration => _responseDuration;

  @override
  String get responseString => _responseString;
}
