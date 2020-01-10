import 'package:enigma_web/src/bouquet_item_bouquet.dart';
import 'package:enigma_web/src/commands/i_get_bouquets_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_bouquet_item_bouquet.dart';
import 'package:enigma_web/src/known_exception.dart';
import 'package:enigma_web/src/operation_cancelled_exception.dart';
import 'package:enigma_web/src/parsers/helpers.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/parsers/parsing_exception.dart';
import 'package:enigma_web/src/responses/get_bouquets_response.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';
import 'package:enigma_web/src/string_helper.dart';
import 'package:xml/xml.dart' as xml;

class GetBouquetsParser
    implements IResponseParser<IGetBouquetsCommand, GetBouquetsResponse> {
  @override
  Future<GetBouquetsResponse> parseAsync(
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

  GetBouquetsResponse parseE1(IStringResponse response) {
    var bouquets = <IBouquetItemBouquet>[];
    var lines = response.responseString.split('\n');
    for (var i = 0; i <= lines.length - 2; i++) {
      //IBouquetItemBouquet bq = BouquetItemBouquet();
      var reference = lines[i].substring(0, lines[i].indexOf(';')).trim();
      reference = StringHelper.trimAll(reference);
      var name = lines[i].substring(lines[i].indexOf(';') + 1).trim();
      name = StringHelper.trimAll(name);
      if (lines[i].contains(';selected')) {
        name = name.substring(0, name.indexOf(';selected'));
      }
      bouquets.add(
        BouquetItemBouquet(
          name: name,
          reference: reference,
        ),
      );
    }
    return GetBouquetsResponse(bouquets, response.responseDuration);
  }

  GetBouquetsResponse parseE2(IStringResponse response) {
    var responseString = Helpers.sanitizeXmlString(response.responseString);
    var bouquets = <IBouquetItemBouquet>[];

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
          bouquets.add(
            BouquetItemBouquet(
              name: serviceName,
              reference: serviceReference,
            ),
          );
        }
      }
    }
    return GetBouquetsResponse(bouquets, response.responseDuration);
  }
}
