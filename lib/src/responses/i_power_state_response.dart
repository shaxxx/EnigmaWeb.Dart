import '../commands/i_power_state_command.dart';
import '../responses/i_response.dart';

abstract class IPowerStateResponse implements IResponse<IPowerStateCommand> {
  bool standby = false;
}
