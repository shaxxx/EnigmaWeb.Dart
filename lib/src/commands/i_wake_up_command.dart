import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../i_profile.dart';
import '../responses/i_response.dart';

abstract class IWakeUpCommand implements ICommand {
  Future<IResponse<IWakeUpCommand>> executeAsync(IProfile profile,
      {CancelToken token});
}
