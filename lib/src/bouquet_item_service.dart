import 'package:enigma_web/src/i_bouquet_item_service.dart';

class BouquetItemService implements IBouquetItemService {
  final String name;
  final String reference;

  BouquetItemService({
    this.name,
    this.reference,
  })  : assert(name != null),
        assert(reference != null);

  @override
  int get hashCode => name.hashCode ^ reference.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BouquetItemService &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          reference == other.reference;

  @override
  String toString() {
    return 'Service $name, reference $reference';
  }
}
