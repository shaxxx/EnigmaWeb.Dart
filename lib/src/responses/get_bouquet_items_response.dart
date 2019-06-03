import '../i_bouquet_item.dart';
import '../responses/i_get_bouquet_items_response.dart';

class GetBouquetItemsResponse implements IGetBouquetItemsResponse {
  GetBouquetItemsResponse.withItems(List<IBouquetItem> items) {
    this.items = items;
  }

  GetBouquetItemsResponse() {
    items = List<IBouquetItem>();
  }

  @override
  List<IBouquetItem> items;
}
