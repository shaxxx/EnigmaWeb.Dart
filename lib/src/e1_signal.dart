import 'package:enigma_web/src/i_e1_signal.dart';

class E1Signal implements IE1Signal {
  final int acg;
  final int ber;
  final bool lock;
  final int snr;
  final bool sync;

  E1Signal({
    this.acg = 0,
    this.ber = 0,
    this.lock = false,
    this.snr = 0,
    this.sync = false,
  })  : assert(acg != null),
        assert(ber != null),
        assert(lock != null),
        assert(snr != null),
        assert(sync != null);

  @override
  String get calculatedDb {
    return (snr / 6.5).toStringAsFixed(2);
  }

  @override
  int get hashCode =>
      acg.hashCode ^
      ber.hashCode ^
      lock.hashCode ^
      snr.hashCode ^
      sync.hashCode;

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
