import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_sleep_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/i_web_requester.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_response.dart';

class SleepCommand
    extends EnigmaCommand<ISleepCommand, IResponse<ISleepCommand>>
    implements ISleepCommand {
  final IResponseParser<ISleepCommand, IResponse<ISleepCommand>> parser;
  @override
  final IProfile profile;
  SleepCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
  )   : assert(parser != null),
        assert(profile != null),
        super(requester);

  @override
  Future<IResponse<ISleepCommand>> executeAsync() async {
    var url = profile.enigma == EnigmaType.enigma1
        ? 'cgi-bin/admin?command=standby&requester=webif'
        : 'web/powerstate?newstate=5';
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
    );
  }
}
