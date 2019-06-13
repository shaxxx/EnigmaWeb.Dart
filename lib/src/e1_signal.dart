import 'package:enigma_web/src/i_e1_signal.dart';

class E1Signal implements IE1Signal {
  @override
  int acg = 0;
  @override
  int ber = 0;
  @override
  bool lock = false;
  @override
  int snr = 0;
  @override
  bool sync = false;

  @override
  String get calculatedDb {
    return (snr / 6.5).toStringAsFixed(2);
  }

  @override
  int get hashCode => acg.hashCode ^ ber.hashCode ^ lock.hashCode ^ snr.hashCode ^ sync.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is E1Signal &&
          runtimeType == other.runtimeType &&
          acg == other.acg &&
          ber == other.ber &&
          lock == other.lock &&
          snr == other.snr &&
          sync == other.sync;

  @override
  String toString() {
    return 'E1Signal acg: $acg, ber: $ber, snr: $snr';
  }
}
