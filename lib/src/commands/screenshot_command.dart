import 'package:enigma_web/enigma_web.dart';

class ScreenshotCommand
    extends EnigmaCommand<IScreenshotCommand, IScreenshotResponse>
    implements IScreenshotCommand {
  @override
  final IProfile profile;
  @override
  final ScreenshotType type;

  ScreenshotCommand(
    super.requester,
    this.profile,
    this.type,
  );

  @override
  Future<IScreenshotResponse> executeAsync() async {
    try {
      String url;
      if (type == ScreenshotType.all) {
        url = profile.enigma == EnigmaType.enigma1
            ? 'body?mode=controlScreenShot&blendtype=2'
            : 'grab?format=jpg&filename=/tmp/${_unixTimeStamp()}.jpg';
      } else if (type == ScreenshotType.picture) {
        url = profile.enigma == EnigmaType.enigma1
            ? 'body?mode=controlScreenShot'
            : 'grab?format=jpg&v=&filename=/tmp/${_unixTimeStamp()}.jpg';
      } else if (type == ScreenshotType.osd) {
        url = profile.enigma == EnigmaType.enigma1
            ? 'body?mode=controlFBShot'
            : 'grab?format=jpg&o=&filename=/tmp/${_unixTimeStamp()}.jpg';
      } else {
        throw Exception('Screenshot type not supported.');
      }

      if (profile.enigma == EnigmaType.enigma2) {
        var binaryResponse = await requester.getBinaryResponseAsync(
          url,
          profile,
        );
        return ScreenshotResponse(
          binaryResponse.content,
          binaryResponse.responseDuration,
        );
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

      await requester.getResponseAsync(
        url,
        profile,
      );
      var binaryResponse = await requester.getBinaryResponseAsync(
        url,
        profile,
      );
      return ScreenshotResponse(
        binaryResponse.content,
        binaryResponse.responseDuration,
      );
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }

      throw CommandException(
        'Command failed for profile ${profile.name}\n$ex',
      );
    }
  }

  static String _unixTimeStamp() {
    return (DateTime.now().millisecondsSinceEpoch).toString();
  }
}
