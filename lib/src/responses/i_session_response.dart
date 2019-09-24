import 'package:enigma_web/src/commands/i_session_command.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class ISessionResponse implements IResponse<ISessionCommand> {
  String get sessionId;
}
