import 'package:enigma_web/src/i_volume_status.dart';
import 'package:enigma_web/src/responses/i_volume_status_response.dart';

class VolumeStatusResponse implements IVolumeStatusResponse {
  final IVolumeStatus _status;
  final Duration _responseDuration;

  VolumeStatusResponse(this._status, this._responseDuration)
      : assert(_status != null),
        assert(_responseDuration != null);

  @override
  IVolumeStatus get status => _status;

  @override
  Duration get responseDuration => _responseDuration;
}
