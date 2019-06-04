//import 'package:logging/logging.dart';
import 'package:xml/xml.dart' as xml;

import '../commands/i_get_current_service_command.dart';
import '../enums.dart';
import '../i_bouquet_item_service.dart';
import '../i_bouquet_item_service_e1.dart';
import '../i_factory.dart';
import '../known_exception.dart';
import '../operation_cancelled_exception.dart';
import '../parsers/helpers.dart';
import '../parsers/i_response_parser.dart';
import '../parsers/parsing_exception.dart';
import '../responses/i_get_current_service_response.dart';
import '../string_helper.dart';

class GetCurrentServiceParser
    implements IResponseParser<IGetCurrentServiceCommand, IGetCurrentServiceResponse> {
  IFactory _factory;
  //Logger _log;

  GetCurrentServiceParser(IFactory factory) {
    if (factory == null) {
      throw ArgumentError.notNull("factory");
    }

    _factory = factory;
    //_log = factory.log;
  }

  @override
  Future<IGetCurrentServiceResponse> parseAsync(String response, EnigmaType enigmaType) async {
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

  IGetCurrentServiceResponse parseE1(String response) {
    IBouquetItemServiceE1 service = _factory.bouquetItemServiceE1();
    service.name = getE1StatusValue(response, "var serviceName = " "");
    service.reference = getE1StatusValue(response, "var serviceReference = " "");
    service.vlcParms = getE1StatusValue(response, "var vlcparms = " "");
    return _factory.getCurrentServiceResponseWithService(service);
  }

  String getE1StatusValue(String response, String searchFor) {
    String tmp = response.substring(response.indexOf(searchFor) + searchFor.length);
    return StringHelper.trimAll(tmp.substring(0, tmp.indexOf(";")));
  }

  IGetCurrentServiceResponse parseE2(String response) {
    response = Helpers.sanitizeXmlString(response);
    IBouquetItemService service = _factory.bouquetItemService();
    var document = xml.parse(response);

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

    service.name = serviceName;
    service.reference = serviceReference;

    return _factory.getCurrentServiceResponseWithService(service);
  }
}
