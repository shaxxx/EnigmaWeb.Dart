import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IRemoteControlCommand implements ICommand {
  RemoteControlCode get code;
  Future<IResponse<IRemoteControlCommand>> executeAsync({CancelToken token});
}
