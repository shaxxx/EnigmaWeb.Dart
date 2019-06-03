import '../commands/i_get_bouquets_command.dart';
import '../i_bouquet_item_bouquet.dart';
import '../responses/i_response.dart';

abstract class IGetBouquetsResponse implements IResponse<IGetBouquetsCommand> {
  List<IBouquetItemBouquet> bouquets;
}
