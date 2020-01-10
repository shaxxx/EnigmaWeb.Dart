//import 'package:logging/logging.dart';

import 'package:enigma_web/src/commands/i_get_stream_parameters_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/known_exception.dart';
import 'package:enigma_web/src/operation_cancelled_exception.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/parsers/parsing_exception.dart';
import 'package:enigma_web/src/responses/get_stream_parameters_response.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';
import 'package:enigma_web/src/string_helper.dart';

class GetStreamParametersParser
    implements
        IResponseParser<IGetStreamParametersCommand,
            GetStreamParametersResponse> {
  @override
  Future<GetStreamParametersResponse> parseAsync(
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

  GetStreamParametersResponse parseE1(IStringResponse response) {
    return parseE2(response);
  }

  GetStreamParametersResponse parseE2(IStringResponse response) {
    var lf = '\n';
    var streamUrl = '';
    var lines = response.responseString.split(lf);
    if (lines != null && lines.isNotEmpty) {
      var link = lines.where((x) => x.toLowerCase().startsWith('http'));
      if (link != null && link.isNotEmpty) {
        if (!StringHelper.stringIsNullOrEmpty(link.first)) {
          streamUrl = StringHelper.trimAll(link.first);
        }
      }
    }
    return GetStreamParametersResponse(
        streamUrl, response.responseString, response.responseDuration);
  }
}
