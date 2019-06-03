import '../i_signal.dart';
import '../responses/i_signal_response.dart';

class SignalResponse implements ISignalResponse {
  SignalResponse(ISignal signal) {
    this.signal = signal;
  }

  @override
  ISignal signal;
}
