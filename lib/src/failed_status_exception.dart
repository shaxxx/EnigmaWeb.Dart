import 'package:enigma_web/src/known_exception.dart';

class FailedStatusCodeException extends KnownException {
  final int? statusCode;
  FailedStatusCodeException(super.message, this.statusCode,
      {super.innerException});
}
