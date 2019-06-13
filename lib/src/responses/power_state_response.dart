import 'package:enigma_web/src/responses/i_power_state_response.dart';

class PowerStateResponse implements IPowerStateResponse {
  final bool _standby;
  final Duration _responseDuration;

  PowerStateResponse(this._standby, this._responseDuration)
      : assert(_standby != null),
        assert(_responseDuration != null);

  @override
  bool get standby => _standby;

  @override
  Duration get responseDuration => _responseDuration;
}
