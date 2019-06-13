import 'package:enigma_web/src/commands/i_command.dart';

abstract class IBinaryResponse<TCommand extends ICommand> {
  List<int> get content;
  Duration get responseDuration;
}
