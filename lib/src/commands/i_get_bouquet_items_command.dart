import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/i_bouquet_item_bouquet.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/responses/i_get_bouquet_items_response.dart';

abstract class IGetBouquetItemsCommand implements ICommand {
  Future<IGetBouquetItemsResponse> executeAsync(
      IProfile profile, IBouquetItemBouquet bouquet,
      {CancelToken token});
}
