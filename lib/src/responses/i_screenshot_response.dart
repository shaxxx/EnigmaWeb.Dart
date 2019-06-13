import 'package:enigma_web/src/commands/i_screenshot_command.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IScreenshotResponse implements IResponse<IScreenshotCommand> {
  List<int> get screenshot;
}
