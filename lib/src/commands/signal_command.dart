import 'package:dio/dio.dart';
import 'package:enigma_web/enigma_web.dart';
import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_signal_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_signal_response.dart';

class SignalCommand extends EnigmaCommand<ISignalCommand, ISignalResponse>
    implements ISignalCommand {
  final IResponseParser<ISignalCommand, ISignalResponse> parser;
  final IProfile profile;

  SignalCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
  )   : assert(parser != null),
        assert(profile != null),
        super(requester);

  @override
  Future<ISignalResponse> executeAsync({CancelToken token}) async {
    String url =
        profile.enigma == EnigmaType.enigma1 ? "satFinder" : "web/signal";
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
      token: token,
    );
  }
}
