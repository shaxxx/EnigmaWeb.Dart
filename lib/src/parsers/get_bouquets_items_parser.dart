//import 'package:logging/logging.dart';
import 'package:xml/xml.dart' as xml;

import '../commands/i_get_bouquet_items_command.dart';
import '../enums.dart';
import '../i_bouquet_item.dart';
import '../i_factory.dart';
import '../known_exception.dart';
import '../operation_cancelled_exception.dart';
import '../parsers/helpers.dart';
import '../parsers/i_response_parser.dart';
import '../parsers/parsing_exception.dart';
import '../responses/i_get_bouquet_items_response.dart';
import '../string_helper.dart';

class GetBouquetItemsParser
    implements
        IResponseParser<IGetBouquetItemsCommand, IGetBouquetItemsResponse> {
  IFactory _factory;
  //Logger _log;

  GetBouquetItemsParser(IFactory factory) {
    if (factory == null) {
      throw ArgumentError.notNull("factory");
    }
    _factory = factory;
    //_log = factory.log;
  }

  @override
  Future<IGetBouquetItemsResponse> parseAsync(
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

  IGetBouquetItemsResponse parseE1(String response) {
    var items = List<IBouquetItem>();
    List<String> lines = response.split("\n");

    for (int i = 0; i <= lines.length - 2; i++) {
      String reference = lines[i].substring(0, lines[i].indexOf(";"));
      reference = StringHelper.trimAll(reference);
      IBouquetItem item = _initializeItem(reference, EnigmaType.enigma1);
      if (item == null) {
        continue;
      }

      String name = lines[i].substring(lines[i].indexOf(";") + 1);
      name = StringHelper.trimAll(name);

      if (name.indexOf(";") > -1) {
        name = name.substring(0, name.indexOf(";"));
        name = StringHelper.trimAll(name);
      }

      item.reference = reference;
      item.name = name;
      items.add(item);
    }
    return _factory.getBouquetItemsResponseWithItems(items);
  }

  IGetBouquetItemsResponse parseE2(String response) {
    response = Helpers.sanitizeXmlString(response);
    var items = List<IBouquetItem>();

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
          var item = _initializeItem(serviceReference, EnigmaType.enigma2);
          item.name = serviceName;
          items.add(item);
        }
      }
    }
    return _factory.getBouquetItemsResponseWithItems(items);
  }

  IBouquetItem _initializeItem(String reference, EnigmaType enigmaType) {
    if (StringHelper.stringIsNullOrEmpty(reference)) {
      return null;
    }

    if (reference.startsWith("1:0:1")) {
      return enigmaType == EnigmaType.enigma2
          ? _factory.bouquetItemService()
          : _factory.bouquetItemServiceE1();
    }

    if (reference.startsWith("1:64")) {
      return _factory.bouquetItemMarker();
    }

    return _factory.bouquetItemBouquet();
  }
}
