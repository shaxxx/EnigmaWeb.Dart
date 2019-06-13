import 'package:enigma_web/src/i_signal.dart';
import 'package:enigma_web/src/responses/i_signal_response.dart';

class SignalResponse implements ISignalResponse {
  final ISignal _signal;
  final Duration _responseDuration;

  SignalResponse(this._signal, this._responseDuration)
      : assert(_signal != null),
        assert(_responseDuration != null) {}

  @override
  ISignal get signal => _signal;

  @override
  Duration get responseDuration => _responseDuration;
}
