import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../enums.dart';
import '../i_profile.dart';
import '../responses/i_response.dart';

abstract class IRemoteControlCommand implements ICommand {
  Future<IResponse<IRemoteControlCommand>> executeAsync(IProfile profile, RemoteControlCode code,
      {CancelToken token});
}
