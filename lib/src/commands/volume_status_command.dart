import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_volume_status_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_volume_status_response.dart';

class VolumeStatusCommand
    extends EnigmaCommand<IVolumeStatusCommand, IVolumeStatusResponse>
    implements IVolumeStatusCommand {
  IResponseParser<IVolumeStatusCommand, IVolumeStatusResponse> _parser;

  VolumeStatusCommand(IFactory factory) : super(factory) {
    _parser = factory.volumeStatusParser();
  }

  @override
  Future<IVolumeStatusResponse> executeAsync(IProfile profile,
      {CancelToken token}) async {
    String url = profile.enigma == EnigmaType.enigma1 ? "data" : "web/vol";
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
