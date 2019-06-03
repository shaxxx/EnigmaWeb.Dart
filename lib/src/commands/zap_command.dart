import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_zap_command.dart';
import '../enums.dart';
import '../i_bouquet_item_service.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_response.dart';

class ZapCommand extends EnigmaCommand<IZapCommand, IResponse<IZapCommand>>
    implements IZapCommand {
  IResponseParser<IZapCommand, IResponse<IZapCommand>> _parser;

  ZapCommand(IFactory factory) : super(factory) {
    _parser = factory.zapParser();
  }

  @override
  Future<IResponse<IZapCommand>> executeAsync(
      IProfile profile, IBouquetItemService service,
      {CancelToken token}) async {
    if (service == null) {
      throw ArgumentError.notNull("service");
    }

    String url = profile.enigma == EnigmaType.enigma1
        ? "cgi-bin/zapTo?path="
        : "web/zap?sRef=";
    url = url + service.reference;
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
