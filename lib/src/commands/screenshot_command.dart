import 'package:dio/dio.dart';
import 'package:enigma_web/enigma_web.dart';
import 'package:enigma_web/src/commands/command_exception.dart';
import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_screenshot_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/known_exception.dart';
import 'package:enigma_web/src/operation_cancelled_exception.dart';
import 'package:enigma_web/src/responses/i_screenshot_response.dart';

class ScreenshotCommand
    extends EnigmaCommand<IScreenshotCommand, IScreenshotResponse>
    implements IScreenshotCommand {
  ScreenshotCommand(IWebRequester requester) : super(requester);

  @override
  Future<IScreenshotResponse> executeAsync(
      IProfile profile, ScreenshotType type,
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
                : "grab?format=jpg&mode=all&filename=/tmp/" +
                    _unixTimeStamp() +
                    ".jpg";
            break;
          }
        case ScreenshotType.picture:
          {
            url = profile.enigma == EnigmaType.enigma1
                ? "body?mode=controlScreenShot"
                : "grab?format=jpg&mode=video&v=&filename=/tmp/" +
                    _unixTimeStamp() +
                    ".jpg";
            break;
          }
        case ScreenshotType.osd:
          {
            url = profile.enigma == EnigmaType.enigma1
                ? "body?mode=controlFBShot"
                : "grab?format=jpg&mode=osd&o=&n=&filename=/tmp/" +
                    _unixTimeStamp() +
                    ".jpg";
            break;
          }
        default:
          {
            throw Exception("Screenshot type not supported.");
          }
      }

      if (profile.enigma == EnigmaType.enigma2) {
        var binaryResponse = await requester
            .getBinaryResponseAsync(url, profile, cancelToken: token);
        if (binaryResponse != null) {
          return ScreenshotResponse(
              binaryResponse.content, binaryResponse.responseDuration);
        }
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

      var response =
          await requester.getResponseAsync(url, profile, cancelToken: token);
      if (response == null) {
        return null;
      }
      var binaryResponse = await requester.getBinaryResponseAsync(url, profile,
          cancelToken: token);
      if (binaryResponse != null) {
        return ScreenshotResponse(
            binaryResponse.content, binaryResponse.responseDuration);
      }
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }

      throw CommandException("Command failed for profile ${profile.name}\n$ex");
    }
    throw CommandException(
        "Screenshot failed for profile ${profile.name}\nEmpty response!");
  }

  static String _unixTimeStamp() {
    return (DateTime.now().millisecond / 1000).toString();
  }
}
