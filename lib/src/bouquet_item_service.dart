import 'package:enigma_web/src/i_bouquet_item_service.dart';
import 'package:meta/meta.dart';

class BouquetItemService implements IBouquetItemService {
  @override
  final String name;
  @override
  final String reference;

  BouquetItemService({
    @required this.name,
    @required this.reference,
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
