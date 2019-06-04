//import 'package:logging/logging.dart';

import '../commands/i_get_stream_parameters_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../known_exception.dart';
import '../operation_cancelled_exception.dart';
import '../parsers/i_response_parser.dart';
import '../parsers/parsing_exception.dart';
import '../responses/i_get_stream_parameters_response.dart';
import '../string_helper.dart';

class GetStreamParametersParser
    implements IResponseParser<IGetStreamParametersCommand, IGetStreamParametersResponse> {
  IFactory _factory;
  //Logger _log;

  GetStreamParametersParser(IFactory factory) {
    if (factory == null) {
      throw ArgumentError.notNull("factory");
    }
    _factory = factory;
    //_log = factory.log;
  }

  @override
  Future<IGetStreamParametersResponse> parseAsync(String response, EnigmaType enigmaType) async {
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

  IGetStreamParametersResponse parseE1(String response) {
    return parseE2(response);
  }

  IGetStreamParametersResponse parseE2(String response) {
    String lf = '\n';
    var spr = _factory.getStreamParametersResponseWithResponse(response);
    spr.m3uFileContent = response;
    var lines = response.split(lf);
    if (lines != null && lines.isNotEmpty) {
      var link = lines.where((x) => x.toLowerCase().startsWith("http"));
      if (link != null && link.isNotEmpty) {
        if (!StringHelper.stringIsNullOrEmpty(link.first)) {
          spr.streamUrl = StringHelper.trimAll(link.first);
        }
      }
    }
    return spr;
  }
}
