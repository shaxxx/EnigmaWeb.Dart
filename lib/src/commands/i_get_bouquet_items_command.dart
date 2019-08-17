import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/i_bouquet_item_bouquet.dart';
import 'package:enigma_web/src/responses/i_get_bouquet_items_response.dart';

abstract class IGetBouquetItemsCommand extends ICommand {
  IBouquetItemBouquet get bouquet;
  Future<IGetBouquetItemsResponse> executeAsync({CancelToken token});
}
