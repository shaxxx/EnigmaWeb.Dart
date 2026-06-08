import 'package:enigma_web/src/known_exception.dart';

class OperationCanceledException extends KnownException {
  OperationCanceledException(super.message, {super.innerException});
}
