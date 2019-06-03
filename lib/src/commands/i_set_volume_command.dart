import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../i_profile.dart';
import '../responses/i_response.dart';

abstract class ISetVolumeCommand implements ICommand {
  Future<IResponse<ISetVolumeCommand>> executeAsync(IProfile profile, int level,
      {CancelToken token});
}
