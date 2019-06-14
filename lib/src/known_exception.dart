abstract class KnownException implements Exception {
  final String message;
  final Exception innerException;
  KnownException(this.message, {this.innerException}) : assert(message != null);
}
