import 'dart:io';

import 'known_exception.dart';

class FailedStatusCodeException implements KnownException {
  HttpStatus statusCode;

  FailedStatusCodeException(String message, HttpStatus statusCode) {
    statusCode = statusCode;
  }

  FailedStatusCodeException.withException(
      String message, HttpStatus statusCode, Exception innerException) {
    statusCode = statusCode;
  }
}
