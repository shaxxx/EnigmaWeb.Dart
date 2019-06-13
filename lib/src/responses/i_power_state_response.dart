import 'package:enigma_web/src/commands/i_power_state_command.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IPowerStateResponse implements IResponse<IPowerStateCommand> {
  bool get standby;
}
