import '../commands/i_signal_command.dart';
import '../i_signal.dart';
import '../responses/i_response.dart';

abstract class ISignalResponse implements IResponse<ISignalCommand> {
  ISignal signal;
}
