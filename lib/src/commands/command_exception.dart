import 'package:enigma_web/src/known_exception.dart';

class CommandException implements KnownException {
  String message;
  Exception innerException;

  CommandException(String message) : message = message;
  CommandException.withException(String message, Exception innerException)
      : message = message,
        innerException = innerException;
}
