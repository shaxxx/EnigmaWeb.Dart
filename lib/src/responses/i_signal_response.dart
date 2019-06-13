import 'package:enigma_web/src/commands/i_signal_command.dart';
import 'package:enigma_web/src/i_signal.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class ISignalResponse implements IResponse<ISignalCommand> {
  ISignal get signal;
}
