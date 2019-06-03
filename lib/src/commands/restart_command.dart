import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_restart_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_response.dart';

class RestartCommand
    extends EnigmaCommand<IRestartCommand, IResponse<IRestartCommand>>
    implements IRestartCommand {
  IResponseParser<IRestartCommand, IResponse<IRestartCommand>> _parser;

  RestartCommand(IFactory factory) : super(factory) {
    _parser = factory.restartParser();
  }

  @override
  Future<IResponse<IRestartCommand>> executeAsync(IProfile profile,
      {CancelToken token}) async {
    String url = profile.enigma == EnigmaType.enigma1
        ? "cgi-bin/admin?command=restart&requester=webif"
        : "web/powerstate?newstate=3";
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
