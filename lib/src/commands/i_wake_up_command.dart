import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IWakeUpCommand implements ICommand {
  Future<IResponse<IWakeUpCommand>> executeAsync();
}
