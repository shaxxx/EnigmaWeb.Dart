import '../responses/i_get_stream_parameters_response.dart';

class GetStreamParametersResponse implements IGetStreamParametersResponse {
  GetStreamParametersResponse() {
    streamUrl = "";
    m3uFileContent = "";
  }

  GetStreamParametersResponse.withResponse(String response) {
    streamUrl = "";
    m3uFileContent = response;
  }

  @override
  String streamUrl;

  @override
  String m3uFileContent;
}
