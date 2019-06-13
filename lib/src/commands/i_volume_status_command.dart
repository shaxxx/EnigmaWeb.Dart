import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/responses/i_volume_status_response.dart';

abstract class IVolumeStatusCommand implements ICommand {
  Future<IVolumeStatusResponse> executeAsync(IProfile profile,
      {CancelToken token});
}
