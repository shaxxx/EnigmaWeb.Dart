//import 'package:logging/logging.dart';

import 'package:enigma_web/src/commands/i_session_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/known_exception.dart';
import 'package:enigma_web/src/operation_cancelled_exception.dart';
import 'package:enigma_web/src/parsers/helpers.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/parsers/parsing_exception.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';
import 'package:enigma_web/src/responses/session_response.dart';
import 'package:enigma_web/src/string_helper.dart';
import 'package:xml/xml.dart' as xml;

class SessionParser
    implements IResponseParser<ISessionCommand, SessionResponse> {
  @override
  Future<SessionResponse> parseAsync(
      IStringResponse response, EnigmaType enigmaType) async {
    try {
      return await Future(() => parseE2(response));
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }
      throw ParsingException("Failed to parse response\n$response",
          innerException: ex);
    }
  }

  SessionResponse parseE2(IStringResponse response) {
    var responseString = Helpers.sanitizeXmlString(response.responseString);
    var document = xml.parse(responseString);
    var node = document.findAllElements("e2sessionid");
    if (node != null && node.isNotEmpty) {
      var value = StringHelper.trimAll(node.first.text);
      return SessionResponse(value, response.responseDuration);
    }
    throw ParsingException(
        "Failed to parse Enigma2 session. Xml tag <e2sessionid> not found!");
  }
}
