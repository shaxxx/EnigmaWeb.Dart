import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../enums.dart';
import '../i_profile.dart';
import '../responses/i_response.dart';

abstract class IMessageCommand implements ICommand {
  Future<IResponse<IMessageCommand>> executeAsync(
      IProfile profile, MessageType type, String message, int timeout,
      {CancelToken token});
}
