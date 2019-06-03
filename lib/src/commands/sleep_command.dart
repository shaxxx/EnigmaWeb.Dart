import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_sleep_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_response.dart';

class SleepCommand
    extends EnigmaCommand<ISleepCommand, IResponse<ISleepCommand>>
    implements ISleepCommand {
  IResponseParser<ISleepCommand, IResponse<ISleepCommand>> _parser;

  SleepCommand(IFactory factory) : super(factory) {
    _parser = factory.sleepParser();
  }

  @override
  Future<IResponse<ISleepCommand>> executeAsync(IProfile profile,
      {CancelToken token}) async {
    String url = profile.enigma == EnigmaType.enigma1
        ? "cgi-bin/admin?command=standby&requester=webif"
        : "web/powerstate?newstate=5";
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
