import 'package:enigma_web/src/commands/i_volume_status_command.dart';
import 'package:enigma_web/src/i_volume_status.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IVolumeStatusResponse
    implements IResponse<IVolumeStatusCommand> {
  IVolumeStatus get status;
}
