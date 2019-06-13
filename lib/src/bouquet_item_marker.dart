import 'package:enigma_web/src/i_bouquet_item_marker.dart';

class BouquetItemMarker implements IBouquetItemMarker {
  String name;
  String reference;

  @override
  int get hashCode => name.hashCode ^ reference.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BouquetItemMarker &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          reference == other.reference;

  @override
  String toString() {
    return 'Marker $name, reference $reference';
  }
}
