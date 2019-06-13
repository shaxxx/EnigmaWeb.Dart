import 'package:enigma_web/src/known_exception.dart';

class ParsingException implements KnownException {
  ParsingException(String message);

  ParsingException.withException(String message, Exception innerException);
}
