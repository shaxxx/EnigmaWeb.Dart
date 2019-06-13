import 'package:enigma_web/src/commands/i_get_bouquet_items_command.dart';
import 'package:enigma_web/src/i_bouquet_item.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IGetBouquetItemsResponse
    implements IResponse<IGetBouquetItemsCommand> {
  List<IBouquetItem> get items;
}
