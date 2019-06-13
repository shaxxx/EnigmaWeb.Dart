import 'package:enigma_web/src/commands/i_get_bouquets_command.dart';
import 'package:enigma_web/src/i_bouquet_item_bouquet.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IGetBouquetsResponse implements IResponse<IGetBouquetsCommand> {
  List<IBouquetItemBouquet> get bouquets;
}
