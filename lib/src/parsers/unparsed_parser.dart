import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/known_exception.dart';
import 'package:enigma_web/src/operation_cancelled_exception.dart';
import 'package:enigma_web/src/parsers/i_unparsed_parser.dart';
import 'package:enigma_web/src/parsers/parsing_exception.dart';
import 'package:enigma_web/src/responses/i_response.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';
import 'package:enigma_web/src/responses/unparsed_response.dart';

class UnparsedParser<TCommand extends ICommand>
    implements IUnparsedParser<TCommand> {
  @override
  Future<IResponse<TCommand>> parseAsync(
      IStringResponse response, EnigmaType enigmaType) async {
    try {
      return await Future(() =>
          UnparsedResponse<TCommand>(response, response.responseDuration));
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }
      throw ParsingException.withException(
          "Failed to parse response\n$response", ex);
    }
  }
}
