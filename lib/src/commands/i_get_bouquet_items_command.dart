import 'package:dio/dio.dart';

import '../i_bouquet_item_bouquet.dart';
import '../i_profile.dart';
import '../responses/i_get_bouquet_items_response.dart';
import 'i_command.dart';

abstract class IGetBouquetItemsCommand implements ICommand {
  Future<IGetBouquetItemsResponse> executeAsync(IProfile profile, IBouquetItemBouquet bouquet,
      {CancelToken token});
}
