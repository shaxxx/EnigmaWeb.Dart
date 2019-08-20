import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_power_state_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/i_web_requester.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_power_state_response.dart';

class PowerStateCommand
    extends EnigmaCommand<IPowerStateCommand, IPowerStateResponse>
    implements IPowerStateCommand {
  final IResponseParser<IPowerStateCommand, IPowerStateResponse> parser;
  final IProfile profile;

  PowerStateCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
  )   : assert(parser != null),
        assert(profile != null),
        super(requester);

  @override
  Future<IPowerStateResponse> executeAsync() async {
    String url =
        profile.enigma == EnigmaType.enigma1 ? "data" : "web/powerstate";
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
    );
  }
}
