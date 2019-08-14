import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class IMessageCommand implements ICommand {
  MessageType get type;
  String get message;
  int get timeout;
  Future<IResponse<IMessageCommand>> executeAsync({CancelToken token});
}
