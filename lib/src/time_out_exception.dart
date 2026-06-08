import 'package:enigma_web/src/web_request_exception.dart';

class TimeOutException extends WebRequestException {
  final String url;
  final Duration timeOut;
  TimeOutException(
    super.message,
    this.url,
    this.timeOut, {
    super.innerException,
  });
}
