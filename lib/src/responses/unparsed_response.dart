import '../commands/i_command.dart';
import '../responses/i_unparsed_response.dart';

class UnparsedResponse<TCommand extends ICommand>
    implements IUnparsedResponse<TCommand> {
  UnparsedResponse(String response) {
    this.response = response;
  }

  @override
  String response;
}
