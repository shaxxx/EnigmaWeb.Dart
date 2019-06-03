import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_signal_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_signal_response.dart';

class SignalCommand extends EnigmaCommand<ISignalCommand, ISignalResponse>
    implements ISignalCommand {
  IResponseParser<ISignalCommand, ISignalResponse> _parser;

  SignalCommand(IFactory factory) : super(factory) {
    _parser = factory.signalParser();
  }

  @override
  Future<ISignalResponse> executeAsync(IProfile profile,
      {CancelToken token}) async {
    String url =
        profile.enigma == EnigmaType.enigma1 ? "satFinder" : "web/signal";
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
