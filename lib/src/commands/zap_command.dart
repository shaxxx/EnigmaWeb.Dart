import 'package:dio/dio.dart';
import 'package:enigma_web/enigma_web.dart';
import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_zap_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_bouquet_item_service.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_response.dart';

class ZapCommand extends EnigmaCommand<IZapCommand, IResponse<IZapCommand>> implements IZapCommand {
  final IResponseParser<IZapCommand, IResponse<IZapCommand>> parser;

  ZapCommand(this.parser, IWebRequester requester)
      : assert(parser != null),
        super(requester) {}

  @override
  Future<IResponse<IZapCommand>> executeAsync(IProfile profile, IBouquetItemService service,
      {CancelToken token}) async {
    if (service == null) {
      throw ArgumentError.notNull("service");
    }

    String url = profile.enigma == EnigmaType.enigma1 ? "cgi-bin/zapTo?path=" : "web/zap?sRef=";
    url = url + service.reference;
    return await super.executeGenericAsync(profile, url, parser, token: token);
  }
}
