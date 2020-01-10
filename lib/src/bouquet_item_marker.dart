import 'package:enigma_web/src/i_bouquet_item_marker.dart';
import 'package:meta/meta.dart';

class BouquetItemMarker implements IBouquetItemMarker {
  @override
  final String name;
  @override
  final String reference;

  BouquetItemMarker({
    @required this.name,
    @required this.reference,
  })  : assert(name != null),
        assert(reference != null);

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
