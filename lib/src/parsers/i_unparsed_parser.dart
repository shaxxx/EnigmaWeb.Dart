import '../commands/i_command.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_response.dart';

abstract class IUnparsedParser<TCommand extends ICommand>
    implements IResponseParser<TCommand, IResponse<TCommand>> {}
