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
  @override
  final IProfile profile;
  @override
  final ScreenshotType type;
  ScreenshotCommand(
    IWebRequester requester,
    this.profile,
    this.type,
  )   : assert(profile != null),
        assert(type != null),
        super(requester);

  @override
  Future<IScreenshotResponse> executeAsync() async {
    try {
      String url;
      if (type == ScreenshotType.all) {
        url = profile.enigma == EnigmaType.enigma1
            ? 'body?mode=controlScreenShot&blendtype=2'
            : 'grab?format=jpg&filename=/tmp/' + _unixTimeStamp() + '.jpg';
      } else if (type == ScreenshotType.picture) {
        url = profile.enigma == EnigmaType.enigma1
            ? 'body?mode=controlScreenShot'
            : 'grab?format=jpg&v=&filename=/tmp/' + _unixTimeStamp() + '.jpg';
      } else if (type == ScreenshotType.osd) {
        url = profile.enigma == EnigmaType.enigma1
            ? 'body?mode=controlFBShot'
            : 'grab?format=jpg&o=&filename=/tmp/' + _unixTimeStamp() + '.jpg';
      } else {
        throw Exception('Screenshot type not supported.');
      }

      if (profile.enigma == EnigmaType.enigma2) {
        var binaryResponse = await requester.getBinaryResponseAsync(
          url,
          profile,
        );
        if (binaryResponse != null) {
          return ScreenshotResponse(
            binaryResponse.content,
            binaryResponse.responseDuration,
          );
        }
      }

      //Enigma 1
      await requester.getResponseAsync(
        url,
        profile,
      );

      if (type == ScreenshotType.osd) {
        url = 'root/tmp/osdshot.png';
      } else {
        url = 'root/tmp/screenshot.bmp';
      }

      var response = await requester.getResponseAsync(
        url,
        profile,
      );
      if (response == null) {
        return null;
      }
      var binaryResponse = await requester.getBinaryResponseAsync(
        url,
        profile,
      );
      if (binaryResponse != null) {
        return ScreenshotResponse(
          binaryResponse.content,
          binaryResponse.responseDuration,
        );
      }
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }

      throw CommandException(
        'Command failed for profile ${profile.name}\n$ex',
      );
    }
    throw CommandException(
      'Screenshot failed for profile ${profile.name}\nEmpty response!',
    );
  }

  static String _unixTimeStamp() {
    return (DateTime.now().millisecondsSinceEpoch).toString();
  }
}
