import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/responses/i_get_current_service_response.dart';

abstract class IGetCurrentServiceCommand implements ICommand {
  Future<IGetCurrentServiceResponse> executeAsync();
}
