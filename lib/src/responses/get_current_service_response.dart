import 'package:enigma_web/src/i_bouquet_item_service.dart';
import 'package:enigma_web/src/responses/i_get_current_service_response.dart';

class GetCurrentServiceResponse implements IGetCurrentServiceResponse {
  final IBouquetItemService _currentService;
  final Duration _responseDuration;

  GetCurrentServiceResponse(this._currentService, this._responseDuration)
      : assert(_currentService != null),
        assert(_responseDuration != null);

  @override
  IBouquetItemService get currentService => _currentService;

  @override
  Duration get responseDuration => _responseDuration;
}
