import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/responses/i_screenshot_response.dart';

abstract class IScreenshotCommand implements ICommand {
  Future<IScreenshotResponse> executeAsync(
      IProfile profile, ScreenshotType type,
      {CancelToken token});
}
