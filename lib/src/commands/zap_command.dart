import 'package:enigma_web/enigma_web.dart';

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
  ) : super(requester);

  @override
  Future<IResponse<IZapCommand>> executeAsync() async {
    var url = profile.enigma == EnigmaType.enigma1
        ? 'cgi-bin/zapTo?path=${Uri.encodeFull(service.reference!)}'
        : 'web/zap?sRef=${Uri.encodeComponent(service.reference!)}';
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
    );
  }
}
