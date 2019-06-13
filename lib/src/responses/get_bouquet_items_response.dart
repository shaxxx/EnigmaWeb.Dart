import 'package:enigma_web/src/i_bouquet_item.dart';
import 'package:enigma_web/src/responses/i_get_bouquet_items_response.dart';

class GetBouquetItemsResponse implements IGetBouquetItemsResponse {
  final List<IBouquetItem> _items;
  final Duration _responseDuration;

  GetBouquetItemsResponse(this._items, this._responseDuration)
      : assert(_items != null),
        assert(_responseDuration != null);

  @override
  List<IBouquetItem> get items => _items;

  @override
  Duration get responseDuration => _responseDuration;
}
