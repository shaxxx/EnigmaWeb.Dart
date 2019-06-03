//import 'package:logging/logging.dart';
import 'package:xml/xml.dart' as xml;

import '../commands/i_get_bouquets_command.dart';
import '../enums.dart';
import '../i_bouquet_item_bouquet.dart';
import '../i_factory.dart';
import '../known_exception.dart';
import '../operation_cancelled_exception.dart';
import '../responses/i_get_bouquets_response.dart';
import '../string_helper.dart';
import 'helpers.dart';
import 'i_response_parser.dart';
import 'parsing_exception.dart';

class GetBouquetsParser
    implements IResponseParser<IGetBouquetsCommand, IGetBouquetsResponse> {
  IFactory _factory;
  //Logger _log;

  GetBouquetsParser(IFactory factory) {
    if (factory == null) {
      throw ArgumentError.notNull("factory");
    }
    _factory = factory;
    //_log = factory.log;
  }

  @override
  Future<IGetBouquetsResponse> parseAsync(
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

  IGetBouquetsResponse parseE1(String response) {
    var bouquets = List<IBouquetItemBouquet>();
    List<String> lines = response.split("\n");
    for (int i = 0; i <= lines.length - 2; i++) {
      IBouquetItemBouquet bq = _factory.bouquetItemBouquet();
      bq.reference = lines[i].substring(0, lines[i].indexOf(";")).trim();
      bq.reference = StringHelper.trimAll(bq.reference);
      bq.name = lines[i].substring(lines[i].indexOf(";") + 1).trim();
      bq.name = StringHelper.trimAll(bq.name);
      if (lines[i].indexOf(";selected") > -1) {
        bq.name = bq.name.substring(0, bq.name.indexOf(";selected"));
      }
      bouquets.add(bq);
    }
    return _factory.getBouquetsResponseWithBouquets(bouquets);
  }

  IGetBouquetsResponse parseE2(String response) {
    response = Helpers.sanitizeXmlString(response);
    var bouquets = List<IBouquetItemBouquet>();

    var document = xml.parse(response);
    var children = document.findAllElements("e2service");
    if (children != null && children.isNotEmpty) {
      for (final node in children) {
        final serviceReferenceNode = node.findAllElements("e2servicereference");
        final serviceNameNode = node.findAllElements("e2servicename");

        String serviceReference;
        String serviceName;

        if (serviceReferenceNode != null && serviceReferenceNode.isNotEmpty) {
          serviceReference =
              StringHelper.trimAll(serviceReferenceNode.first.text);
        }

        if (serviceNameNode != null && serviceNameNode.isNotEmpty) {
          serviceName = StringHelper.trimAll(serviceNameNode.first.text);
        }

        if (serviceReference != null) {
          var bouquet = _factory.bouquetItemBouquet();
          bouquet.name = serviceName;
          bouquet.reference = serviceReference;
          bouquets.add(bouquet);
        }
      }
    }
    return _factory.getBouquetsResponseWithBouquets(bouquets);
  }
}
