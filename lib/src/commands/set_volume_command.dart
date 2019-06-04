import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_set_volume_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_response.dart';

class SetVolumeCommand extends EnigmaCommand<ISetVolumeCommand, IResponse<ISetVolumeCommand>>
    implements ISetVolumeCommand {
  IResponseParser<ISetVolumeCommand, IResponse<ISetVolumeCommand>> _parser;

  SetVolumeCommand(IFactory factory) : super(factory) {
    _parser = factory.setVolumeParser();
  }

  @override
  Future<IResponse<ISetVolumeCommand>> executeAsync(IProfile profile, int level,
      {CancelToken token}) async {
    if (level > 100 || level < 0) {
      throw ArgumentError.notNull("level");
    }

    String url = profile.enigma == EnigmaType.enigma1 ? "/setVolume?volume=" : "web/vol?set=set";
    url = url + level.toString();
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
