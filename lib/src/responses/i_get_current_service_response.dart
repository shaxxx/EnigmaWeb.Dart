import '../commands/i_get_current_service_command.dart';
import '../i_bouquet_item_service.dart';
import '../responses/i_response.dart';

abstract class IGetCurrentServiceResponse implements IResponse<IGetCurrentServiceCommand> {
  IBouquetItemService currentService;
}
