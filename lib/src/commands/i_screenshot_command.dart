import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/responses/i_screenshot_response.dart';

abstract class IScreenshotCommand implements ICommand {
  ScreenshotType get type;
  Future<IScreenshotResponse> executeAsync();
}
