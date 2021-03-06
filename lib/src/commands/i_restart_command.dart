import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IRestartCommand implements ICommand {
  Future<IResponse<IRestartCommand>> executeAsync();
}
