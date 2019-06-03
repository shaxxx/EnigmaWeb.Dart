import '../commands/i_screenshot_command.dart';
import '../responses/i_response.dart';

abstract class IScreenshotResponse implements IResponse<IScreenshotCommand> {
  List<int> screenshot = [];
}
