abstract class KnownException implements Exception {
  KnownException(String message);
  KnownException.withException(String message, Exception innerException);
}
