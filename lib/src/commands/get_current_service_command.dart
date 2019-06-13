import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_get_current_service_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/i_web_requester.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_get_current_service_response.dart';

class GetCurrentServiceCommand extends EnigmaCommand<IGetCurrentServiceCommand, IGetCurrentServiceResponse>
    implements IGetCurrentServiceCommand {
  final IResponseParser<IGetCurrentServiceCommand, IGetCurrentServiceResponse> parser;

  GetCurrentServiceCommand(this.parser, IWebRequester requester)
      : assert(parser != null),
        super(requester) {}

  @override
  Future<IGetCurrentServiceResponse> executeAsync(IProfile profile, {CancelToken token}) async {
    String url = profile.enigma == EnigmaType.enigma1 ? "data" : "web/getcurrent";
    return await super.executeGenericAsync(profile, url, parser, token: token);
  }
}
