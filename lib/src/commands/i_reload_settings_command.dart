import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IReloadSettingsCommand implements ICommand {
  ReloadSettingsType get type;
  Future<IResponse<IReloadSettingsCommand>> executeAsync({CancelToken token});
}
