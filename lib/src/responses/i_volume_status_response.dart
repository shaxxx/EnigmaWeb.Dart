import '../commands/i_volume_status_command.dart';
import '../i_volume_status.dart';
import '../responses/i_response.dart';

abstract class IVolumeStatusResponse
    implements IResponse<IVolumeStatusCommand> {
  IVolumeStatus status;
}
