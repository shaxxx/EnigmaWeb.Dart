import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_get_stream_parameters_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_bouquet_item_service.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/i_web_requester.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_get_stream_parameters_response.dart';

class GetStreamParametersCommand extends EnigmaCommand<
    IGetStreamParametersCommand,
    IGetStreamParametersResponse> implements IGetStreamParametersCommand {
  IResponseParser<IGetStreamParametersCommand, IGetStreamParametersResponse>
      parser;
  @override
  final IProfile profile;
  @override
  final IBouquetItemService service;
  GetStreamParametersCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
    this.service,
  )   : assert(parser != null),
        assert(profile != null),
        assert(service != null),
        super(requester);

  @override
  Future<IGetStreamParametersResponse> executeAsync() async {
    if (profile == null) {
      throw ArgumentError.notNull('profile');
    }

    if (service == null) {
      throw ArgumentError.notNull('service');
    }

    var url = profile.enigma == EnigmaType.enigma1
        ? 'video.m3u?ref=' + service.reference
        : 'web/video.m3u?sRef=' + Uri.encodeComponent(service.reference);

    return await super.executeGenericAsync(
      profile,
      url,
      parser,
    );
  }
}
