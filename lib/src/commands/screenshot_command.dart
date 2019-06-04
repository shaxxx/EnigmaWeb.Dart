import 'package:dio/dio.dart';

import '../commands/command_exception.dart';
import '../commands/enigma_command.dart';
import '../commands/i_screenshot_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../known_exception.dart';
import '../operation_cancelled_exception.dart';
import '../responses/i_screenshot_response.dart';

class ScreenshotCommand extends EnigmaCommand<IScreenshotCommand, IScreenshotResponse>
    implements IScreenshotCommand {
  IFactory _factory;

  ScreenshotCommand(IFactory factory) : super(factory) {
    _factory = factory;
  }

  @override
  Future<IScreenshotResponse> executeAsync(IProfile profile, ScreenshotType type,
      {CancelToken token}) async {
    if (profile == null) {
      throw ArgumentError.notNull("profile");
    }

    try {
      String url;
      switch (type) {
        case ScreenshotType.all:
          {
            url = profile.enigma == EnigmaType.enigma1
                ? "body?mode=controlScreenShot&blendtype=2"
                : "grab?format=jpg&mode=all&filename=/tmp/" + _unixTimeStamp() + ".jpg";
            break;
          }
        case ScreenshotType.picture:
          {
            url = profile.enigma == EnigmaType.enigma1
                ? "body?mode=controlScreenShot"
                : "grab?format=jpg&mode=video&v=&filename=/tmp/" + _unixTimeStamp() + ".jpg";
            break;
          }
        case ScreenshotType.osd:
          {
            url = profile.enigma == EnigmaType.enigma1
                ? "body?mode=controlFBShot"
                : "grab?format=jpg&mode=osd&o=&n=&filename=/tmp/" + _unixTimeStamp() + ".jpg";
            break;
          }
        default:
          {
            throw Exception("Screenshot type not supported.");
          }
      }

      if (profile.enigma == EnigmaType.enigma2) {
        return _factory.screenshotResponseWithBytes(
            await requester.getBinaryResponseAsync(url, profile, cancelToken: token));
      }

      //Enigma 1
      await requester.getResponseAsync(url, profile, cancelToken: token);

      switch (type) {
        case ScreenshotType.osd:
          {
            url = "root/tmp/osdshot.png";
            break;
          }
        default:
          {
            url = "root/tmp/screenshot.bmp";
          }
      }

      String response = await requester.getResponseAsync(url, profile, cancelToken: token);
      if (response == null) {
        return null;
      }
      return _factory.screenshotResponseWithBytes(
          await requester.getBinaryResponseAsync(url, profile, cancelToken: token));
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }

      throw CommandException("Command failed for profile ${profile.name}\n$ex");
    }
  }

  static String _unixTimeStamp() {
    return (DateTime.now().millisecond / 1000).toString();
  }
}
