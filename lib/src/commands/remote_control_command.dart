import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_remote_control_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_response.dart';

class RemoteControlCommand
    extends EnigmaCommand<IRemoteControlCommand, IResponse<IRemoteControlCommand>>
    implements IRemoteControlCommand {
  IResponseParser<IRemoteControlCommand, IResponse<IRemoteControlCommand>> _parser;

  RemoteControlCommand(IFactory factory) : super(factory) {
    _parser = factory.remoteControlParser();
  }

  @override
  Future<IResponse<IRemoteControlCommand>> executeAsync(IProfile profile, RemoteControlCode code,
      {CancelToken token}) async {
    String url =
        profile.enigma == EnigmaType.enigma1 ? "cgi-bin/rc?" : "web/remotecontrol?command=";
    url = url + code.value.toString();
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
