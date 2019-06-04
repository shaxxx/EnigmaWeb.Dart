import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../enums.dart';
import '../i_profile.dart';
import '../responses/i_screenshot_response.dart';

abstract class IScreenshotCommand implements ICommand {
  Future<IScreenshotResponse> executeAsync(IProfile profile, ScreenshotType type,
      {CancelToken token});
}
