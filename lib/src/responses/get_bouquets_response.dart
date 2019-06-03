import '../i_bouquet_item_bouquet.dart';
import '../responses/i_get_bouquets_response.dart';

class GetBouquetsResponse implements IGetBouquetsResponse {
  GetBouquetsResponse.withBouquets(List<IBouquetItemBouquet> bouquets) {
    this.bouquets = bouquets;
  }

  GetBouquetsResponse() {
    this.bouquets = List<IBouquetItemBouquet>();
  }

  @override
  List<IBouquetItemBouquet> bouquets;
}
