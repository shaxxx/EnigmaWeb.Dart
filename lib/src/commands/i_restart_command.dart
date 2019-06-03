import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../i_profile.dart';
import '../responses/i_response.dart';

abstract class IRestartCommand implements ICommand {
  Future<IResponse<IRestartCommand>> executeAsync(IProfile profile,
      {CancelToken token});
}
