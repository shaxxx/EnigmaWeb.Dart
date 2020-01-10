import 'package:enigma_web/src/i_bouquet_item_bouquet.dart';
import 'package:meta/meta.dart';

class BouquetItemBouquet implements IBouquetItemBouquet {
  @override
  final String name;
  @override
  final String reference;

  BouquetItemBouquet({
    @required this.name,
    @required this.reference,
  })  : assert(name != null),
        assert(reference != null);

  @override
  int get hashCode => name.hashCode ^ reference.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BouquetItemBouquet &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          reference == other.reference;

  @override
  String toString() {
    return 'Bouquet $name, reference $reference';
  }
}
