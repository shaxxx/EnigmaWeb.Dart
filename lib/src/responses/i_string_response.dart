import 'package:enigma_web/src/commands/i_command.dart';

abstract class IStringResponse<TCommand extends ICommand> {
  final String responseString;
  final Duration responseDuration;

  IStringResponse(this.responseString, this.responseDuration);
}
