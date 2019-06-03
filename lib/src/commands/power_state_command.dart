import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_power_state_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_power_state_response.dart';

class PowerStateCommand
    extends EnigmaCommand<IPowerStateCommand, IPowerStateResponse>
    implements IPowerStateCommand {
  IResponseParser<IPowerStateCommand, IPowerStateResponse> _parser;

  PowerStateCommand(IFactory factory) : super(factory) {
    _parser = factory.powerStateParser();
  }

  @override
  Future<IPowerStateResponse> executeAsync(IProfile profile,
      {CancelToken token}) async {
    String url =
        profile.enigma == EnigmaType.enigma1 ? "data" : "web/powerstate";
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
