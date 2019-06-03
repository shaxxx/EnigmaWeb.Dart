import 'i_bouquet_item_bouquet.dart';

class BouquetItemBouquet implements IBouquetItemBouquet {
  @override
  String name;
  @override
  String reference;

  @override
  String toString() {
    return name;
  }
}
