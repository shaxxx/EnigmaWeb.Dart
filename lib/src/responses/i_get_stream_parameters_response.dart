import 'package:enigma_web/src/commands/i_get_stream_parameters_command.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IGetStreamParametersResponse implements IResponse<IGetStreamParametersCommand> {
  String get streamUrl;
  String get m3uFileContent;
}
