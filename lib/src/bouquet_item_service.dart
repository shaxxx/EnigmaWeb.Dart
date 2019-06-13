import 'package:enigma_web/src/i_bouquet_item_service.dart';

class BouquetItemService implements IBouquetItemService {
  String name;
  String reference;

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
