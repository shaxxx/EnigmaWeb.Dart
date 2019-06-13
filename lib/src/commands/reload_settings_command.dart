import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_reload_settings_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/i_web_requester.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_response.dart';

class ReloadSettingsCommand extends EnigmaCommand<IReloadSettingsCommand,
    IResponse<IReloadSettingsCommand>> implements IReloadSettingsCommand {
  final IResponseParser<IReloadSettingsCommand,
      IResponse<IReloadSettingsCommand>> parser;

  ReloadSettingsCommand(this.parser, IWebRequester requester)
      : assert(parser != null),
        super(requester);

  @override
  Future<IResponse<IReloadSettingsCommand>> executeAsync(
    IProfile profile,
    ReloadSettingsType type, {
    CancelToken token,
  }) async {
    if (profile.enigma == EnigmaType.enigma1) {
      if (type == ReloadSettingsType.all) {
        await super.executeGenericAsync(
            profile, "cgi-bin/reloadSettings", parser,
            token: token);
        return await super.executeGenericAsync(
            profile, "cgi-bin/reloadUserBouquets", parser,
            token: token);
      }
      if (type == ReloadSettingsType.services) {
        return await super.executeGenericAsync(
            profile, "cgi-bin/reloadSettings", parser,
            token: token);
      }
      if (type == ReloadSettingsType.bouquets) {
        return await super.executeGenericAsync(
            profile, "cgi-bin/reloadUserBouquets", parser,
            token: token);
      }
      throw Exception("ReloadSettingsType not supported");
    }
    return await super.executeGenericAsync(
        profile, "web/servicelistreload?mode=${type.index}", parser,
        token: token);
  }
}
