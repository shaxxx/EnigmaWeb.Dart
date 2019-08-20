import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/responses/i_power_state_response.dart';

abstract class IPowerStateCommand implements ICommand {
  Future<IPowerStateResponse> executeAsync();
}
