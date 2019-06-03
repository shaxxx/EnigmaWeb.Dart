import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../i_profile.dart';
import '../responses/i_volume_status_response.dart';

abstract class IVolumeStatusCommand implements ICommand {
  Future<IVolumeStatusResponse> executeAsync(IProfile profile,
      {CancelToken token});
}
