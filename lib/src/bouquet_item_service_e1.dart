import 'package:enigma_web/src/bouquet_item_service.dart';
import 'package:enigma_web/src/i_bouquet_item_service_e1.dart';

class BouquetItemServiceE1 extends BouquetItemService
    implements IBouquetItemServiceE1 {
  final String vlcParms;

  BouquetItemServiceE1({
    String reference,
    String name,
    this.vlcParms,
  }) : super(reference: reference, name: name);

  @override
  int get hashCode => name.hashCode ^ reference.hashCode ^ vlcParms.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BouquetItemServiceE1 &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          reference == other.reference &&
          vlcParms == other.vlcParms;

  @override
  String toString() {
    return 'Service $name, reference $reference';
  }
}
