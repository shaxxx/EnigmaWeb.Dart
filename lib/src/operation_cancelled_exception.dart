import 'package:enigma_web/src/known_exception.dart';

class OperationCanceledException implements KnownException {
  String message;
  Exception innerException;

  OperationCanceledException(String message) : message = message;
  OperationCanceledException.withException(
      String message, Exception innerException)
      : message = message,
        innerException = innerException;
}
