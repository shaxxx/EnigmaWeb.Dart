import 'package:enigma_web/src/i_bouquet_item_bouquet.dart';

class BouquetItemBouquet implements IBouquetItemBouquet {
  final String name;
  final String reference;

  BouquetItemBouquet({
    this.name,
    this.reference,
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
