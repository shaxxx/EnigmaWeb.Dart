import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class ISetVolumeCommand implements ICommand {
  Future<IResponse<ISetVolumeCommand>> executeAsync(IProfile profile, int level,
      {CancelToken token});
}
