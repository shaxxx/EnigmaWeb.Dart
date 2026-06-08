import 'package:enigma_web/src/known_exception.dart';

class ParsingException extends KnownException {
  ParsingException(super.message, {super.innerException});
}
