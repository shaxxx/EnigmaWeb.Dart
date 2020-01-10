import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_remote_control_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/i_web_requester.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_response.dart';

class RemoteControlCommand extends EnigmaCommand<IRemoteControlCommand,
    IResponse<IRemoteControlCommand>> implements IRemoteControlCommand {
  final IResponseParser<IRemoteControlCommand, IResponse<IRemoteControlCommand>>
      parser;
  @override
  final IProfile profile;
  @override
  final RemoteControlCode code;

  RemoteControlCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
    this.code,
  )   : assert(parser != null),
        assert(profile != null),
        assert(code != null),
        super(requester);

  @override
  Future<IResponse<IRemoteControlCommand>> executeAsync() async {
    var url;
    if (profile.enigma == EnigmaType.enigma1) {
      url = 'cgi-bin/rc?';
    } else {
      url = 'web/remotecontrol?command=';
    }
    url = url + code.value.toString();
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
    );
  }
}
