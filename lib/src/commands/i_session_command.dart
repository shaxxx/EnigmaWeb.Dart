import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/responses/i_session_response.dart';

abstract class ISessionCommand implements ICommand {
  Future<ISessionResponse> executeAsync();
}
