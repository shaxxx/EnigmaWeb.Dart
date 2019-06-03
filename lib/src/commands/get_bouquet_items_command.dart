import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_get_bouquet_items_command.dart';
import '../enums.dart';
import '../i_bouquet_item_bouquet.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_get_bouquet_items_response.dart';

class GetBouquetItemsCommand
    extends EnigmaCommand<IGetBouquetItemsCommand, IGetBouquetItemsResponse>
    implements IGetBouquetItemsCommand {
  IResponseParser<IGetBouquetItemsCommand, IGetBouquetItemsResponse> _parser;

  GetBouquetItemsCommand(IFactory factory) : super(factory) {
    _parser = factory.getBouquetItemsParser();
  }

  @override
  Future<IGetBouquetItemsResponse> executeAsync(
      IProfile profile, IBouquetItemBouquet bouquet,
      {CancelToken token}) async {
    if (bouquet == null) {
      throw ArgumentError.notNull("bouquet");
    }

    String url = profile.enigma == EnigmaType.enigma1
        ? "cgi-bin/getServices?ref="
        : "web/getservices?sRef=";
    url = url + bouquet.reference;
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
