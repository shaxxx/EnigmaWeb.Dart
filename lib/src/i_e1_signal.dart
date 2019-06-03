import 'i_signal.dart';

abstract class IE1Signal implements ISignal {
  bool lock = false;

  bool sync = false;

  String get calculatedDb => "0.0";
}
