import '../responses/i_screenshot_response.dart';

class ScreenshotResponse implements IScreenshotResponse {
  ScreenshotResponse(List<int> screenshot) {
    this.screenshot = screenshot;
  }

  @override
  List<int> screenshot = [];
}
