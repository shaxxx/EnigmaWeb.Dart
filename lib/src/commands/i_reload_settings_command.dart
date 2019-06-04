import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../enums.dart';
import '../i_profile.dart';
import '../responses/i_response.dart';

abstract class IReloadSettingsCommand implements ICommand {
  Future<IResponse<IReloadSettingsCommand>> executeAsync(IProfile profile, ReloadSettingsType type,
      {CancelToken token});
}
