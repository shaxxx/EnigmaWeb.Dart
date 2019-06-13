import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/i_bouquet_item_service.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IZapCommand implements ICommand {
  Future<IResponse<IZapCommand>> executeAsync(IProfile profile, IBouquetItemService service, {CancelToken token});
}
