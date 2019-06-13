import 'package:dio/dio.dart';
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

  RemoteControlCommand(this.parser, IWebRequester requester)
      : assert(parser != null),
        super(requester);

  @override
  Future<IResponse<IRemoteControlCommand>> executeAsync(
      IProfile profile, RemoteControlCode code,
      {CancelToken token}) async {
    String url = profile.enigma == EnigmaType.enigma1
        ? "cgi-bin/rc?"
        : "web/remotecontrol?command=";
    url = url + code.value.toString();
    return await super.executeGenericAsync(profile, url, parser, token: token);
  }
}
