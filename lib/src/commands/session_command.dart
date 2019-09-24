import 'package:enigma_web/enigma_web.dart';
import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_session_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_session_response.dart';

class SessionCommand extends EnigmaCommand<ISessionCommand, ISessionResponse>
    implements ISessionCommand {
  final IResponseParser<ISessionCommand, ISessionResponse> parser;
  final IProfile profile;

  SessionCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
  )   : assert(parser != null),
        assert(profile != null),
        super(requester);

  @override
  Future<ISessionResponse> executeAsync() async {
    String url;
    if (profile.enigma == EnigmaType.enigma1) {
      url = "";
    } else {
      url = "web/session";
    }
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
    );
  }
}
