import 'i_bouquet_item_service.dart';

class BouquetItemService implements IBouquetItemService {
  String name;
  String reference;

  @override
  String toString() {
    return name;
  }
}
