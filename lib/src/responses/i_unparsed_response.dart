import '../commands/i_command.dart';
import '../responses/i_response.dart';

abstract class IUnparsedResponse<TCommand extends ICommand> implements IResponse<TCommand> {
  String response;
}
