import '../commands/i_command.dart';
import '../enums.dart';
import '../responses/i_response.dart';

abstract class IResponseParser<TCommand extends ICommand,
    TResult extends IResponse<TCommand>> {
  Future<TResult> parseAsync(String response, EnigmaType enigmaType);
}
