import 'package:enigma_web/src/known_exception.dart';

class OperationCanceledException extends KnownException {
  OperationCanceledException(String message, {Exception innerException})
      : super(message, innerException: innerException);
}
