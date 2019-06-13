import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IUnparsedParser<TCommand extends ICommand> implements IResponseParser<TCommand, IResponse<TCommand>> {}
