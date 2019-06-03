import 'package:dio/dio.dart';

import '../commands/i_command.dart';
import '../i_bouquet_item_service.dart';
import '../i_profile.dart';
import '../responses/i_response.dart';

abstract class IZapCommand implements ICommand {
  Future<IResponse<IZapCommand>> executeAsync(
      IProfile profile, IBouquetItemService service,
      {CancelToken token});
}
