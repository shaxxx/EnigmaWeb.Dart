import 'package:enigma_web/enigma_web.dart';
import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_zap_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_bouquet_item_service.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_response.dart';

class ZapCommand extends EnigmaCommand<IZapCommand, IResponse<IZapCommand>>
    implements IZapCommand {
  final IResponseParser<IZapCommand, IResponse<IZapCommand>> parser;
  @override
  final IProfile profile;
  @override
  final IBouquetItemService service;

  ZapCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
    this.service,
  )   : assert(parser != null),
        assert(profile != null),
        assert(service != null),
        super(requester);

  @override
  Future<IResponse<IZapCommand>> executeAsync() async {
    var url = profile.enigma == EnigmaType.enigma1
        ? 'cgi-bin/zapTo?path=' + Uri.encodeFull(service.reference)
        : 'web/zap?sRef=' + Uri.encodeComponent(service.reference);
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
    );
  }
}
