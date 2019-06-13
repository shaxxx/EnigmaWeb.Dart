import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';
import 'package:enigma_web/src/responses/i_unparsed_response.dart';

class UnparsedResponse<TCommand extends ICommand> implements IUnparsedResponse<TCommand> {
  final IStringResponse _response;
  final Duration _responseDuration;

  UnparsedResponse(this._response, this._responseDuration) : assert(_response != null, _responseDuration != null) {}

  @override
  IStringResponse get response => _response;

  @override
  Duration get responseDuration => _responseDuration;
}
