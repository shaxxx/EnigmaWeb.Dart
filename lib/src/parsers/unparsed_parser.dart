import '../commands/i_command.dart';
import '../enums.dart';
import '../known_exception.dart';
import '../operation_cancelled_exception.dart';
import '../responses/i_response.dart';
import '../responses/unparsed_response.dart';
import 'i_unparsed_parser.dart';
import 'parsing_exception.dart';

class UnparsedParser<TCommand extends ICommand>
    implements IUnparsedParser<TCommand> {
  @override
  Future<IResponse<TCommand>> parseAsync(
      String response, EnigmaType enigmaType) async {
    try {
      return await Future(() => UnparsedResponse<TCommand>(response));
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }
      throw ParsingException.withException(
          "Failed to parse response\n$response", ex);
    }
  }
}
