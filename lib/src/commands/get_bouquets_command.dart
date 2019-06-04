import 'package:dio/dio.dart';

import '../commands/i_get_bouquets_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_get_bouquets_response.dart';
import 'enigma_command.dart';

class GetBouquetsCommand extends EnigmaCommand<IGetBouquetsCommand, IGetBouquetsResponse>
    implements IGetBouquetsCommand {
  IResponseParser<IGetBouquetsCommand, IGetBouquetsResponse> _parser;

  GetBouquetsCommand(IFactory factory) : super(factory) {
    _parser = factory.getBouquetsParser();
  }

  @override
  Future<IGetBouquetsResponse> executeAsync(IProfile profile, {CancelToken token}) async {
    String url = profile.enigma == EnigmaType.enigma1
        ? "cgi-bin/getServices?ref=4097:7:0:6:0:0:0:0:0:0:"
        : "web/getservices";
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
