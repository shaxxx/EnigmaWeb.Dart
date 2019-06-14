import 'package:enigma_web/src/known_exception.dart';

class ParsingException extends KnownException {
  ParsingException(String message, {Exception innerException})
      : super(message, innerException: innerException);
}
