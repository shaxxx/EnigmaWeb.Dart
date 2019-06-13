import 'package:enigma_web/src/responses/i_get_stream_parameters_response.dart';

class GetStreamParametersResponse implements IGetStreamParametersResponse {
  final String _streamUrl;
  final String _m3uFileContent;
  final Duration _responseDuration;

  GetStreamParametersResponse(this._streamUrl, this._m3uFileContent, this._responseDuration) {}

  @override
  String get streamUrl => _streamUrl;

  @override
  String get m3uFileContent => _m3uFileContent;

  @override
  Duration get responseDuration => _responseDuration;
}
