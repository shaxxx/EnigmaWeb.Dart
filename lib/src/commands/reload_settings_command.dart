import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_reload_settings_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_response.dart';

class ReloadSettingsCommand extends EnigmaCommand<IReloadSettingsCommand,
    IResponse<IReloadSettingsCommand>> implements IReloadSettingsCommand {
  IResponseParser<IReloadSettingsCommand, IResponse<IReloadSettingsCommand>>
      _parser;

  ReloadSettingsCommand(IFactory factory) : super(factory) {
    _parser = factory.reloadSettingsParser();
  }

  @override
  Future<IResponse<IReloadSettingsCommand>> executeAsync(
    IProfile profile,
    ReloadSettingsType type, {
    CancelToken token,
  }) async {
    if (profile.enigma == EnigmaType.enigma1) {
      if (type == ReloadSettingsType.All) {
        await super.executeGenericAsync(
            profile, "cgi-bin/reloadSettings", _parser,
            token: token);
        return await super.executeGenericAsync(
            profile, "cgi-bin/reloadUserBouquets", _parser,
            token: token);
      }
      if (type == ReloadSettingsType.Services) {
        return await super.executeGenericAsync(
            profile, "cgi-bin/reloadSettings", _parser,
            token: token);
      }
      if (type == ReloadSettingsType.Bouquets) {
        return await super.executeGenericAsync(
            profile, "cgi-bin/reloadUserBouquets", _parser,
            token: token);
      }
      throw Exception("ReloadSettingsType not supported");
    }
    return await super.executeGenericAsync(
        profile, "web/servicelistreload?mode=${type.index}", _parser,
        token: token);
  }
}
