import 'package:dio/dio.dart';
import 'package:enigma_web/enigma_web.dart';
import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_volume_status_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_volume_status_response.dart';

class VolumeStatusCommand
    extends EnigmaCommand<IVolumeStatusCommand, IVolumeStatusResponse>
    implements IVolumeStatusCommand {
  final IResponseParser<IVolumeStatusCommand, IVolumeStatusResponse> parser;

  VolumeStatusCommand(this.parser, IWebRequester requester)
      : assert(parser != null),
        super(requester);

  @override
  Future<IVolumeStatusResponse> executeAsync(IProfile profile,
      {CancelToken token}) async {
    String url = profile.enigma == EnigmaType.enigma1 ? "data" : "web/vol";
    return await super.executeGenericAsync(profile, url, parser, token: token);
  }
}
