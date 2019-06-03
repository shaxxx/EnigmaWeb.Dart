import '../responses/i_power_state_response.dart';

class PowerStateResponse implements IPowerStateResponse {
  PowerStateResponse(bool standby) {
    this.standby = standby;
  }

  @override
  bool standby = false;
}
