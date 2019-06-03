import 'i_bouquet_item_marker.dart';

class BouquetItemMarker implements IBouquetItemMarker {
  String name;
  String reference;

  @override
  String toString() {
    return name;
  }
}
