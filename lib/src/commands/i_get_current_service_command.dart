import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../i_profile.dart';
import '../responses/i_get_current_service_response.dart';

abstract class IGetCurrentServiceCommand implements ICommand {
  Future<IGetCurrentServiceResponse> executeAsync(IProfile profile,
      {CancelToken token});
}
