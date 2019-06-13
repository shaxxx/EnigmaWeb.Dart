import 'package:enigma_web/src/commands/i_command.dart';

abstract class IBinaryResponse<TCommand extends ICommand> {
  final List<int> content;
  final Duration responseDuration;

  IBinaryResponse(this.content, this.responseDuration);
}
