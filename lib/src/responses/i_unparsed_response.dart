import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/responses/i_response.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';

abstract class IUnparsedResponse<TCommand extends ICommand>
    implements IResponse<TCommand> {
  IStringResponse get response;
}
