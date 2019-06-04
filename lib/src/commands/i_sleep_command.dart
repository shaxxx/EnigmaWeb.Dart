import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../i_profile.dart';
import '../responses/i_response.dart';

abstract class ISleepCommand implements ICommand {
  Future<IResponse<ISleepCommand>> executeAsync(IProfile profile, {CancelToken token});
}
