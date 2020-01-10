//import 'package:logging/logging.dart';
import 'package:enigma_web/src/commands/i_volume_status_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_volume_status.dart';
import 'package:enigma_web/src/known_exception.dart';
import 'package:enigma_web/src/operation_cancelled_exception.dart';
import 'package:enigma_web/src/parsers/helpers.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/parsers/parsing_exception.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';
import 'package:enigma_web/src/responses/volume_status_response.dart';
import 'package:enigma_web/src/string_helper.dart';
import 'package:enigma_web/src/volume_status.dart';
import 'package:xml/xml.dart' as xml;

class VolumeStatusParser
    implements IResponseParser<IVolumeStatusCommand, VolumeStatusResponse> {
  @override
  Future<VolumeStatusResponse> parseAsync(
      IStringResponse response, EnigmaType enigmaType) async {
    try {
      if (enigmaType == EnigmaType.enigma1) {
        return await Future(() => parseE1(response));
      }

      return await Future(() => parseE2(response));
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }

      throw ParsingException('Failed to parse response\n$response',
          innerException: ex);
    }
  }

  VolumeStatusResponse parseE1(IStringResponse response) {
    var mute = false;
    var current = 0;
    IVolumeStatus status = VolumeStatus();

    var muteString = getE1StatusValue(response.responseString, 'var mute = ');
    var currentString =
        getE1StatusValue(response.responseString, 'var volume = ');
    muteString = StringHelper.trimAll(muteString);
    mute =
        muteString.toLowerCase() == 'true' || muteString.toLowerCase() == '1';
    status.mute = mute;
    currentString = StringHelper.trimAll(currentString);
    current = num.tryParse(currentString);
    if (current == null) {
      throw ParsingException(
          'Enigma1 volume status parsing failed. Unable to convert $currentString to integer value.');
    }
    status.level = current;
    return VolumeStatusResponse(status, null);
  }

  String getE1StatusValue(String response, String searchFor) {
    var tmp =
        response.substring(response.indexOf(searchFor) + searchFor.length);
    return StringHelper.trimAll(tmp.substring(0, tmp.indexOf(';')));
  }

  VolumeStatusResponse parseE2(IStringResponse response) {
    var responseString = Helpers.sanitizeXmlString(response.responseString);
    IVolumeStatus status = VolumeStatus();
    var document = xml.parse(responseString);

    String isMutedString;
    String currentString;

    var mutedNodes = document.findAllElements('e2ismuted');
    if (mutedNodes != null && mutedNodes.isNotEmpty) {
      isMutedString = StringHelper.trimAll(mutedNodes.first.text);
    }

    var currentNodes = document.findAllElements('e2current');
    if (currentNodes != null && currentNodes.isNotEmpty) {
      currentString = StringHelper.trimAll(currentNodes.first.text);
    }

    var intLevel = int.tryParse(currentString);
    if (intLevel == null) {
      throw ParsingException(
          'Enigma2 volume status parsing failed. Unable to convert $currentString to integer value.');
    }

    status.mute = isMutedString.toLowerCase() == 'true' ||
        isMutedString.toLowerCase() == '1';
    status.level = intLevel;

    return VolumeStatusResponse(status, response.responseDuration);
  }
}
