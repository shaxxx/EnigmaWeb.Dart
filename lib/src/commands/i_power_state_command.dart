import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../i_profile.dart';
import '../responses/i_power_state_response.dart';

abstract class IPowerStateCommand implements ICommand {
  Future<IPowerStateResponse> executeAsync(IProfile profile, {CancelToken token});
}
