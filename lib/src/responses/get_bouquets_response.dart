import 'package:enigma_web/src/i_bouquet_item_bouquet.dart';
import 'package:enigma_web/src/responses/i_get_bouquets_response.dart';

class GetBouquetsResponse implements IGetBouquetsResponse {
  final List<IBouquetItemBouquet> _bouquets;
  final Duration _responseDuration;

  GetBouquetsResponse(this._bouquets, this._responseDuration)
      : assert(_bouquets != null),
        assert(_responseDuration != null);

  List<IBouquetItemBouquet> get bouquets => _bouquets;

  @override
  Duration get responseDuration => _responseDuration;
}
