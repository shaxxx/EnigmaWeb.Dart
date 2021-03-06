//import 'package:logging/logging.dart';
import 'package:enigma_web/enigma_web.dart';
import 'package:enigma_web/src/commands/i_get_bouquet_items_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_bouquet_item.dart';
import 'package:enigma_web/src/known_exception.dart';
import 'package:enigma_web/src/operation_cancelled_exception.dart';
import 'package:enigma_web/src/parsers/helpers.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/parsers/parsing_exception.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';
import 'package:enigma_web/src/string_helper.dart';
import 'package:xml/xml.dart' as xml;

class GetBouquetItemsParser
    implements
        IResponseParser<IGetBouquetItemsCommand, GetBouquetItemsResponse> {
  @override
  Future<GetBouquetItemsResponse> parseAsync(
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

  GetBouquetItemsResponse parseE1(IStringResponse response) {
    var items = <IBouquetItem>[];
    var lines = response.responseString.split('\n');

    for (var i = 0; i <= lines.length - 2; i++) {
      var reference = lines[i].substring(0, lines[i].indexOf(';'));
      reference = StringHelper.trimAll(reference);

      if (StringHelper.stringIsNullOrEmpty(reference)) {
        continue;
      }

      var name = lines[i].substring(lines[i].indexOf(';') + 1);
      name = StringHelper.trimAll(name);

      if (name.contains(';')) {
        name = name.substring(0, name.indexOf(';'));
        name = StringHelper.trimAll(name);
      }
      var item = _initializeItem(reference, EnigmaType.enigma1, name);
      if (item != null) {
        items.add(item);
      }
    }
    return GetBouquetItemsResponse(items, response.responseDuration);
  }

  GetBouquetItemsResponse parseE2(IStringResponse response) {
    var responseString = Helpers.sanitizeXmlString(response.responseString);
    var items = <IBouquetItem>[];

    var document = xml.parse(responseString);
    var children = document.findAllElements('e2service');
    if (children != null && children.isNotEmpty) {
      for (final node in children) {
        final serviceReferenceNode = node.findAllElements('e2servicereference');
        final serviceNameNode = node.findAllElements('e2servicename');

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
          var item = _initializeItem(
            serviceReference,
            EnigmaType.enigma2,
            serviceName,
          );
          if (item != null) {
            items.add(item);
          }
        }
      }
    }
    return GetBouquetItemsResponse(items, response.responseDuration);
  }

  IBouquetItem _initializeItem(
    String reference,
    EnigmaType enigmaType,
    String serviceName,
  ) {
    if (StringHelper.stringIsNullOrEmpty(reference)) {
      return null;
    }

    if (reference.startsWith('1:0:1')) {
      return enigmaType == EnigmaType.enigma2
          ? BouquetItemService(
              name: serviceName,
              reference: reference,
            )
          : BouquetItemServiceE1(
              name: serviceName,
              reference: reference,
            );
    }

    if (reference.startsWith('1:64')) {
      return BouquetItemMarker(name: serviceName, reference: reference);
    }

    var sData = StringHelper.trimAll(reference).split(':');
    if (sData.length >= 10 &&
        (sData[0] == '4097' ||
            sData[10].contains('//') ||
            (sData.length == 12 && sData[11] != null))) {
      return enigmaType == EnigmaType.enigma2
          ? BouquetItemService(
              name: serviceName,
              reference: reference,
            )
          : BouquetItemServiceE1(
              name: serviceName,
              reference: reference,
            );
    }

    return BouquetItemBouquet(name: serviceName, reference: reference);
  }
}
