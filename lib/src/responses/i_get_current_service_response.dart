import 'package:enigma_web/src/commands/i_get_current_service_command.dart';
import 'package:enigma_web/src/i_bouquet_item_service.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IGetCurrentServiceResponse implements IResponse<IGetCurrentServiceCommand> {
  IBouquetItemService get currentService;
}
