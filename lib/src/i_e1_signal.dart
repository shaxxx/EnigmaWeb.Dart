import 'package:enigma_web/src/i_signal.dart';

abstract class IE1Signal implements ISignal {
  bool get lock;

  bool get sync;

  String get calculatedDb;
}
