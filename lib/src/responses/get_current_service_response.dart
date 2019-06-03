import '../i_bouquet_item_service.dart';
import '../responses/i_get_current_service_response.dart';

class GetCurrentServiceResponse implements IGetCurrentServiceResponse {
  GetCurrentServiceResponse.withService(IBouquetItemService currentService) {
    this.currentService = currentService;
  }

  GetCurrentServiceResponse();

  @override
  IBouquetItemService currentService;
}
