import 'package:enigma_web/src/known_exception.dart';

class FailedStatusCodeException extends KnownException {
  final int statusCode;
  FailedStatusCodeException(String message, this.statusCode,
      {Exception innerException})
      : super(message, innerException: innerException);
}
