import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_wake_up_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_response.dart';

class WakeUpCommand
    extends EnigmaCommand<IWakeUpCommand, IResponse<IWakeUpCommand>>
    implements IWakeUpCommand {
  IResponseParser<IWakeUpCommand, IResponse<IWakeUpCommand>> _parser;

  WakeUpCommand(IFactory factory) : super(factory) {
    _parser = factory.wakeUpParser();
  }

  @override
  Future<IResponse<IWakeUpCommand>> executeAsync(IProfile profile,
      {CancelToken token}) async {
    String url = profile.enigma == EnigmaType.enigma1
        ? "cgi-bin/admin?command=wakeup&requester=webif"
        : "web/powerstate?newstate=4";
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
