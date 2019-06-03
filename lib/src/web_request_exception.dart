import 'known_exception.dart';

class WebRequestException implements KnownException {
  String message;
  Exception innerException;

  WebRequestException(String message) : message = message;
  WebRequestException.withException(String message, Exception innerException)
      : message = message,
        innerException = innerException;
}
