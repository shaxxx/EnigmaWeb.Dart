import 'package:enigma_web/src/factory.dart';
import 'package:enigma_web/src/i_factory.dart';
import 'package:test/test.dart';
import 'package:enigma_web/enigma_web.dart';
import 'package:logging/logging.dart';

void main() {
  test('e1 snr to db conversion', () {
    final e1signal = E1Signal();
    e1signal.snr = 91;
    expect(e1signal.calculatedDb, "14.00");
  });

  test('default log is working', () {
    IFactory f = Factory();
    String a = "testing default log";
    String b;
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      b = rec.message;
    });
    f.log.finest(a);
    expect(b, a);
  });
}
