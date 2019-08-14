import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_set_volume_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/i_web_requester.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_response.dart';

class SetVolumeCommand
    extends EnigmaCommand<ISetVolumeCommand, IResponse<ISetVolumeCommand>>
    implements ISetVolumeCommand {
  final IResponseParser<ISetVolumeCommand, IResponse<ISetVolumeCommand>> parser;
  final IProfile profile;
  final int level;
  SetVolumeCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
    this.level,
  )   : assert(parser != null),
        assert(profile != null),
        assert(level != null),
        super(requester);

  @override
  Future<IResponse<ISetVolumeCommand>> executeAsync({CancelToken token}) async {
    if (level > 100 || level < 0) {
      throw ArgumentError.value("level");
    }

    String url = profile.enigma == EnigmaType.enigma1
        ? "/setVolume?volume="
        : "web/vol?set=set";
    url = url + level.toString();
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
      token: token,
    );
  }
}
