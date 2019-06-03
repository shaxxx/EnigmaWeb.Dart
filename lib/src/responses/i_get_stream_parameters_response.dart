import '../commands/i_get_stream_parameters_command.dart';
import '../responses/i_response.dart';

abstract class IGetStreamParametersResponse
    implements IResponse<IGetStreamParametersCommand> {
  String streamUrl;
  String m3uFileContent;
}
