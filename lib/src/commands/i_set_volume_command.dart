import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class ISetVolumeCommand implements ICommand {
  int get level;
  Future<IResponse<ISetVolumeCommand>> executeAsync({CancelToken token});
}
