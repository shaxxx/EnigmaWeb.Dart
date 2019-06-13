import 'package:enigma_web/src/responses/i_screenshot_response.dart';

class ScreenshotResponse implements IScreenshotResponse {
  final List<int> _screenshot;
  final Duration _responseDuration;
  ScreenshotResponse(this._screenshot, this._responseDuration)
      : assert(_screenshot != null),
        assert(_responseDuration != null) {}

  @override
  List<int> get screenshot => _screenshot;

  @override
  Duration get responseDuration => _responseDuration;
}
