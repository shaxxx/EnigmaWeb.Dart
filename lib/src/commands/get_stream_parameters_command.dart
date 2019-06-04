import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_get_stream_parameters_command.dart';
import '../enums.dart';
import '../i_bouquet_item_service.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_get_stream_parameters_response.dart';

class GetStreamParametersCommand
    extends EnigmaCommand<IGetStreamParametersCommand, IGetStreamParametersResponse>
    implements IGetStreamParametersCommand {
  IResponseParser<IGetStreamParametersCommand, IGetStreamParametersResponse> _parser;

  GetStreamParametersCommand(IFactory factory) : super(factory) {
    _parser = factory.getStreamParametersParser();
  }

  @override
  Future<IGetStreamParametersResponse> executeAsync(IProfile profile, IBouquetItemService service,
      {CancelToken token}) async {
    if (profile == null) {
      throw ArgumentError.notNull("profile");
    }

    if (service == null) {
      throw ArgumentError.notNull("service");
    }

    String url = profile.enigma == EnigmaType.enigma1 ? "video.m3u?ref=" : "web/video.m3u?sRef=";
    url = url + service.reference;
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
