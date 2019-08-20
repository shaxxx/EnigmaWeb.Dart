import 'package:enigma_web/enigma_web.dart';
import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_get_bouquet_items_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_bouquet_item_bouquet.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_get_bouquet_items_response.dart';

class GetBouquetItemsCommand
    extends EnigmaCommand<IGetBouquetItemsCommand, IGetBouquetItemsResponse>
    implements IGetBouquetItemsCommand {
  final IResponseParser<IGetBouquetItemsCommand, IGetBouquetItemsResponse>
      parser;

  final IProfile profile;
  final IBouquetItemBouquet bouquet;

  GetBouquetItemsCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
    this.bouquet,
  )   : assert(parser != null),
        assert(profile != null),
        assert(bouquet != null),
        super(requester);

  @override
  Future<IGetBouquetItemsResponse> executeAsync() async {
    String url = profile.enigma == EnigmaType.enigma1
        ? "cgi-bin/getServices?ref="
        : "web/getservices?sRef=";
    url = url + bouquet.reference;
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
    );
  }
}
