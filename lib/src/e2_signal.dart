import 'package:enigma_web/src/i_e2_signal.dart';

class E2Signal implements IE2Signal {
  final int acg;
  final int ber;
  final double db;
  final int snr;

  E2Signal({
    this.acg = 0,
    this.ber = 0,
    this.db = 0,
    this.snr = 0,
  })  : assert(acg != null),
        assert(ber != null),
        assert(db != null),
        assert(snr != null);

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
