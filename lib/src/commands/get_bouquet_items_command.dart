import 'package:enigma_web/enigma_web.dart';

class GetBouquetItemsCommand
    extends EnigmaCommand<IGetBouquetItemsCommand, IGetBouquetItemsResponse>
    implements IGetBouquetItemsCommand {
  final IResponseParser<IGetBouquetItemsCommand, IGetBouquetItemsResponse>
      parser;

  @override
  final IProfile profile;
  @override
  final IBouquetItemBouquet bouquet;

  GetBouquetItemsCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
    this.bouquet,
  ) : super(requester);

  @override
  Future<IGetBouquetItemsResponse> executeAsync() async {
    var url = profile.enigma == EnigmaType.enigma1
        ? 'cgi-bin/getServices?ref=${bouquet.reference!}'
        : 'web/getservices?sRef=${Uri.encodeComponent(bouquet.reference!)}';
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
    );
  }
}
