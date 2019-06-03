import 'web_request_exception.dart';

class TimeOutException extends WebRequestException {
  TimeOutException(String message, String url, Duration timeOut)
      : super(message) {
    this.url = url;
    this.timeOut = timeOut;
  }

  TimeOutException.withException(
      String message, String url, Duration timeOut, Exception innerException)
      : super.withException(message, innerException) {
    this.url = url;
    this.timeOut = timeOut;
  }

  String url;
  Duration timeOut;
}
