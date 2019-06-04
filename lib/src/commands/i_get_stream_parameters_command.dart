import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../i_bouquet_item_service.dart';
import '../i_profile.dart';
import '../responses/i_get_stream_parameters_response.dart';

abstract class IGetStreamParametersCommand implements ICommand {
  Future<IGetStreamParametersResponse> executeAsync(IProfile profile, IBouquetItemService service,
      {CancelToken token});
}
