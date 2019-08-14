import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_get_bouquets_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/i_web_requester.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/get_bouquets_response.dart';
import 'package:enigma_web/src/responses/i_get_bouquets_response.dart';

class GetBouquetsCommand
    extends EnigmaCommand<IGetBouquetsCommand, IGetBouquetsResponse>
    implements IGetBouquetsCommand {
  final IResponseParser<IGetBouquetsCommand, GetBouquetsResponse> parser;
  final IProfile profile;

  GetBouquetsCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
  )   : assert(parser != null),
        assert(profile != null),
        super(requester);

  @override
  Future<IGetBouquetsResponse> executeAsync({CancelToken token}) async {
    String url = profile.enigma == EnigmaType.enigma1
        ? "cgi-bin/getServices?ref=4097:7:0:6:0:0:0:0:0:0:"
        : "web/getservices";
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
      token: token,
    );
  }
}
