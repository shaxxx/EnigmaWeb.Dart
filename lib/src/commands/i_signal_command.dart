import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../i_profile.dart';
import '../responses/i_signal_response.dart';

abstract class ISignalCommand implements ICommand {
  Future<ISignalResponse> executeAsync(IProfile profile, {CancelToken token});
}
