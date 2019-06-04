import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_get_current_service_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_get_current_service_response.dart';

class GetCurrentServiceCommand
    extends EnigmaCommand<IGetCurrentServiceCommand, IGetCurrentServiceResponse>
    implements IGetCurrentServiceCommand {
  IResponseParser<IGetCurrentServiceCommand, IGetCurrentServiceResponse> _parser;

  GetCurrentServiceCommand(IFactory factory) : super(factory) {
    _parser = factory.getCurrentServiceParser();
  }

  @override
  Future<IGetCurrentServiceResponse> executeAsync(IProfile profile, {CancelToken token}) async {
    String url = profile.enigma == EnigmaType.enigma1 ? "data" : "web/getcurrent";
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
