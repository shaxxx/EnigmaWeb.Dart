import 'package:enigma_web/src/i_e2_signal.dart';

class E2Signal implements IE2Signal {
  @override
  int acg = 0;
  @override
  int ber = 0;
  @override
  double db = 0.0;
  @override
  int snr = 0;

  @override
  int get hashCode => acg.hashCode ^ ber.hashCode ^ db.hashCode ^ snr.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is E2Signal &&
          runtimeType == other.runtimeType &&
          acg == other.acg &&
          ber == other.ber &&
          db == other.db &&
          snr == other.snr;

  @override
  String toString() {
    return 'E2Signal acg: $acg, ber: $ber, snr: $snr db:$db';
  }
}
