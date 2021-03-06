import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_restart_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/i_web_requester.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_response.dart';

class RestartCommand
    extends EnigmaCommand<IRestartCommand, IResponse<IRestartCommand>>
    implements IRestartCommand {
  final IResponseParser<IRestartCommand, IResponse<IRestartCommand>> parser;
  @override
  final IProfile profile;
  RestartCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
  )   : assert(parser != null),
        assert(profile != null),
        super(requester);

  @override
  Future<IResponse<IRestartCommand>> executeAsync() async {
    String url;
    if (profile.enigma == EnigmaType.enigma1) {
      url = 'cgi-bin/admin?command=restart&requester=webif';
    } else {
      url = 'web/powerstate?newstate=3';
    }
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
    );
  }
}
