import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/responses/i_get_bouquets_response.dart';

abstract class IGetBouquetsCommand implements ICommand {
  Future<IGetBouquetsResponse> executeAsync({CancelToken token});
}
