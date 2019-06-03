import '../i_volume_status.dart';
import '../responses/i_volume_status_response.dart';

class VolumeStatusResponse implements IVolumeStatusResponse {
  VolumeStatusResponse(IVolumeStatus status) {
    if (status == null) {
      throw ArgumentError.notNull("status");
    }

    this.status = status;
  }

  @override
  IVolumeStatus status;
}
