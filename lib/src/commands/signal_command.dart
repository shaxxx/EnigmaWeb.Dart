import 'package:enigma_web/enigma_web.dart';

class SignalCommand extends EnigmaCommand<ISignalCommand, ISignalResponse>
    implements ISignalCommand {
  final IResponseParser<ISignalCommand, ISignalResponse> parser;
  @override
  final IProfile profile;

  SignalCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
  ) : super(requester);

  @override
  Future<ISignalResponse> executeAsync() async {
    var url = profile.enigma == EnigmaType.enigma1 ? 'satFinder' : 'web/signal';
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
    );
  }
}
