import 'dart:io';

import 'package:enigma_web/src/known_exception.dart';

class FailedStatusCodeException extends KnownException {
  final HttpStatus statusCode;
  FailedStatusCodeException(String message, this.statusCode,
      {Exception innerException})
      : super(message, innerException: innerException);
}
