import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../i_profile.dart';
import '../responses/i_get_bouquets_response.dart';

abstract class IGetBouquetsCommand implements ICommand {
  Future<IGetBouquetsResponse> executeAsync(IProfile profile,
      {CancelToken token});
}
