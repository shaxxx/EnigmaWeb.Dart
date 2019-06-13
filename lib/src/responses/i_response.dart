import 'package:enigma_web/src/commands/i_command.dart';

abstract class IResponse<TCommand extends ICommand> {
  final Duration responseDuration;
  IResponse(this.responseDuration);
}
