//import 'package:logging/logging.dart';
import 'package:xml/xml.dart' as xml;

import '../commands/i_volume_status_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_volume_status.dart';
import '../known_exception.dart';
import '../operation_cancelled_exception.dart';
import '../parsers/helpers.dart';
import '../parsers/i_response_parser.dart';
import '../parsers/parsing_exception.dart';
import '../responses/i_volume_status_response.dart';
import '../string_helper.dart';

class VolumeStatusParser
    implements IResponseParser<IVolumeStatusCommand, IVolumeStatusResponse> {
  IFactory _factory;
  //Logger _log;

  VolumeStatusParser(IFactory factory) {
    if (factory == null) {
      throw ArgumentError.notNull("factory");
    }

    _factory = factory;
    //_log = factory.log;
  }

  @override
  Future<IVolumeStatusResponse> parseAsync(
      String response, EnigmaType enigmaType) async {
    try {
      if (enigmaType == EnigmaType.enigma1) {
        return await Future(() => parseE1(response));
      }

      return await Future(() => parseE2(response));
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }

      throw ParsingException.withException(
          "Failed to parse response\n$response", ex);
    }
  }

  IVolumeStatusResponse parseE1(String response) {
    bool mute = false;
    int current = 0;
    IVolumeStatus status = _factory.volumeStatus();

    String muteString = getE1StatusValue(response, "var mute = ");
    String currentString = getE1StatusValue(response, "var volume = ");
    muteString = StringHelper.trimAll(muteString);
    mute =
        muteString.toLowerCase() == "true" || muteString.toLowerCase() == "1";
    status.mute = mute;
    currentString = StringHelper.trimAll(currentString);
    current = num.tryParse(currentString);
    if (current == null) {
      throw ParsingException(
          "Enigma1 volume status parsing failed. Unable to convert $currentString to integer value.");
    }
    status.level = current;
    return _factory.volumeStatusResponseWithResponse(status);
  }

  String getE1StatusValue(String response, String searchFor) {
    String tmp =
        response.substring(response.indexOf(searchFor) + searchFor.length);
    return StringHelper.trimAll(tmp.substring(0, tmp.indexOf(";")));
  }

  IVolumeStatusResponse parseE2(String response) {
    response = Helpers.sanitizeXmlString(response);
    IVolumeStatus status = _factory.volumeStatus();
    var document = xml.parse(response);

    String isMutedString;
    String currentString;

    var mutedNodes = document.findAllElements("e2ismuted");
    if (mutedNodes != null && mutedNodes.isNotEmpty) {
      isMutedString = StringHelper.trimAll(mutedNodes.first.text);
    }

    var currentNodes = document.findAllElements("e2current");
    if (currentNodes != null && currentNodes.isNotEmpty) {
      currentString = StringHelper.trimAll(currentNodes.first.text);
    }

    int intLevel = int.tryParse(currentString);
    if (intLevel == null) {
      throw ParsingException(
          "Enigma2 volume status parsing failed. Unable to convert $currentString to integer value.");
    }

    status.mute = isMutedString.toLowerCase() == "true" ||
        isMutedString.toLowerCase() == "1";
    status.level = intLevel;

    return _factory.volumeStatusResponseWithResponse(status);
  }
}
