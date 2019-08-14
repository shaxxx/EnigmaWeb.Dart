import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/i_bouquet_item_service.dart';
import 'package:enigma_web/src/responses/i_get_stream_parameters_response.dart';

abstract class IGetStreamParametersCommand implements ICommand {
  IBouquetItemService get service;
  Future<IGetStreamParametersResponse> executeAsync({CancelToken token});
}
