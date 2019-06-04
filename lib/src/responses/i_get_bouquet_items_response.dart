import '../commands/i_get_bouquet_items_command.dart';
import '../i_bouquet_item.dart';
import '../responses/i_response.dart';

abstract class IGetBouquetItemsResponse implements IResponse<IGetBouquetItemsCommand> {
  List<IBouquetItem> items;
}
