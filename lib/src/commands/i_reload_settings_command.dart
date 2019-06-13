import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IReloadSettingsCommand implements ICommand {
  Future<IResponse<IReloadSettingsCommand>> executeAsync(IProfile profile, ReloadSettingsType type,
      {CancelToken token});
}
