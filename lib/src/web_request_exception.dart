import 'package:enigma_web/src/known_exception.dart';

class WebRequestException extends KnownException {
  WebRequestException(String message, {Exception innerException})
      : super(message, innerException: innerException);
}
