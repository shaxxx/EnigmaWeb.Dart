import 'i_e1_signal.dart';

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
}
