import 'package:enigma_web/src/bouquet_item_service.dart';
import 'package:enigma_web/src/bouquet_item_service_e1.dart';
import 'package:enigma_web/src/commands/i_get_current_service_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_bouquet_item_service_e1.dart';
import 'package:enigma_web/src/known_exception.dart';
import 'package:enigma_web/src/operation_cancelled_exception.dart';
import 'package:enigma_web/src/parsers/helpers.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/parsers/parsing_exception.dart';
import 'package:enigma_web/src/responses/get_current_service_response.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';
import 'package:enigma_web/src/string_helper.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml.dart' as xml;

class GetCurrentServiceParser
    implements
        IResponseParser<IGetCurrentServiceCommand, GetCurrentServiceResponse> {
  String getE1StatusValue(String response, String searchFor) {
    String tmp =
        response.substring(response.indexOf(searchFor) + searchFor.length);
    return StringHelper.trimAll(tmp.substring(0, tmp.indexOf(";")));
  }

  @override
  Future<GetCurrentServiceResponse> parseAsync(
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
      throw ParsingException("Failed to parse response\n$response",
          innerException: ex);
    }
  }

  GetCurrentServiceResponse parseE1(IStringResponse response) {
    var name = getE1StatusValue(
      response.responseString,
      "var serviceName = " "",
    );
    var reference = getE1StatusValue(
      response.responseString,
      "var serviceReference = " "",
    );
    var vlcParms = getE1StatusValue(
      response.responseString,
      "var vlcparms = " "",
    );
    IBouquetItemServiceE1 service = BouquetItemServiceE1(
      name: name,
      reference: reference,
      vlcParms: vlcParms,
    );
    return GetCurrentServiceResponse(service, response.responseDuration);
  }

  GetCurrentServiceResponse parseE2(IStringResponse response) {
    var responseString = Helpers.sanitizeXmlString(response.responseString);
    var document = xml.parse(responseString);

    String serviceReference;
    String serviceName;

    var refNodes = document.findAllElements("e2servicereference");
    if (refNodes != null && refNodes.isNotEmpty) {
      serviceReference = StringHelper.trimAll(refNodes.first.text);
    }

    var nameNodes = document.findAllElements("e2servicename");
    if (nameNodes != null && nameNodes.isNotEmpty) {
      serviceName = StringHelper.trimAll(nameNodes.first.text);
    }

    try {
      serviceReference = Uri.decodeFull(serviceReference);
    } catch (e) {
      Logger.root.fine(e.toString());
    }

    return GetCurrentServiceResponse(
        BouquetItemService(
          name: serviceName,
          reference: serviceReference,
        ),
        response.responseDuration);
  }
}
