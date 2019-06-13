//import 'package:logging/logging.dart';

import 'package:enigma_web/src/commands/i_power_state_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/known_exception.dart';
import 'package:enigma_web/src/operation_cancelled_exception.dart';
import 'package:enigma_web/src/parsers/helpers.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/parsers/parsing_exception.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';
import 'package:enigma_web/src/responses/power_state_response.dart';
import 'package:enigma_web/src/string_helper.dart';
import 'package:xml/xml.dart' as xml;

class PowerStateParser implements IResponseParser<IPowerStateCommand, PowerStateResponse> {
  @override
  Future<PowerStateResponse> parseAsync(IStringResponse response, EnigmaType enigmaType) async {
    try {
      if (enigmaType == EnigmaType.enigma1) {
        return await Future(() => parseE1(response));
      }
      return await Future(() => parseE2(response));
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }
      throw ParsingException.withException("Failed to parse response\n$response", ex);
    }
  }

  PowerStateResponse parseE1(IStringResponse response) {
    bool standby = false;
    String searchFor = "var standby = ";
    String value = response.responseString.substring(response.responseString.indexOf(searchFor) + searchFor.length);
    value = value.substring(0, value.indexOf(";")).trim();
    value = StringHelper.trimAll(value);
    standby = value.toLowerCase() == "true" || value.toLowerCase() == "1";
    return PowerStateResponse(standby, response.responseDuration);
  }

  PowerStateResponse parseE2(IStringResponse response) {
    var responseString = Helpers.sanitizeXmlString(response.responseString);
    var document = xml.parse(responseString);
    var node = document.findAllElements("e2instandby");
    if (node != null && node.isNotEmpty) {
      var value = StringHelper.trimAll(node.first.text);
      bool standby = false;
      standby = value.toLowerCase() == "true" || value.toLowerCase() == "1";
      return PowerStateResponse(standby, response.responseDuration);
    }
    throw ParsingException("Failed to parse Enigma2 powerstate. Xml tag <e2instandby> not found!");
  }
}
