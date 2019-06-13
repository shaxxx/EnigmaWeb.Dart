import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/responses/i_response.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';

abstract class IResponseParser<TCommand extends ICommand,
    TResult extends IResponse<TCommand>> {
  Future<TResult> parseAsync(IStringResponse response, EnigmaType enigmaType);
}
