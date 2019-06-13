import 'package:enigma_web/src/i_bouquet_item_bouquet.dart';

class BouquetItemBouquet implements IBouquetItemBouquet {
  @override
  String name;
  @override
  String reference;

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
