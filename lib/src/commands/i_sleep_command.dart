import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class ISleepCommand implements ICommand {
  Future<IResponse<ISleepCommand>> executeAsync(IProfile profile, {CancelToken token});
}
