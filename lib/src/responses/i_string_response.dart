import 'package:enigma_web/src/commands/i_command.dart';

abstract class IStringResponse<TCommand extends ICommand> {
  String get responseString;
  Duration get responseDuration;
}
