import 'package:enigma_web/src/known_exception.dart';

class WebRequestException extends KnownException {
  WebRequestException(super.message, {super.innerException});
}
