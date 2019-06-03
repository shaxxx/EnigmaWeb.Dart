//import 'package:logging/logging.dart';

import 'package:xml/xml.dart' as xml;

import '../commands/i_power_state_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../known_exception.dart';
import '../operation_cancelled_exception.dart';
import '../parsers/helpers.dart';
import '../parsers/i_response_parser.dart';
import '../parsers/parsing_exception.dart';
import '../responses/i_power_state_response.dart';
import '../string_helper.dart';

class PowerStateParser
    implements IResponseParser<IPowerStateCommand, IPowerStateResponse> {
  IFactory _factory;
  //Logger _log;

  PowerStateParser(IFactory factory) {
    if (factory == null) {
      throw ArgumentError.notNull("factory");
    }

    _factory = factory;
    //_log = factory.log;
  }

  @override
  Future<IPowerStateResponse> parseAsync(
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

  IPowerStateResponse parseE1(String response) {
    bool standby = false;
    String searchFor = "var standby = ";
    String value =
        response.substring(response.indexOf(searchFor) + searchFor.length);
    value = value.substring(0, value.indexOf(";")).trim();
    value = StringHelper.trimAll(value);
    standby = value.toLowerCase() == "true" || value.toLowerCase() == "1";
    return _factory.powerStateResponse(standby);
  }

  IPowerStateResponse parseE2(String response) {
    response = Helpers.sanitizeXmlString(response);
    var document = xml.parse(response);
    var node = document.findAllElements("e2instandby");
    if (node != null && node.isNotEmpty) {
      var value = StringHelper.trimAll(node.first.text);
      bool standby = false;
      standby = value.toLowerCase() == "true" || value.toLowerCase() == "1";
      return _factory.powerStateResponse(standby);
    }
    throw ParsingException(
        "Failed to parse Enigma2 powerstate. Xml tag <e2instandby> not found!");
  }
}
