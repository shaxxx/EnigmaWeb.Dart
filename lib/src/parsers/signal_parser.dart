//import 'package:logging/logging.dart';
import 'package:enigma_web/src/commands/i_signal_command.dart';
import 'package:enigma_web/src/e1_signal.dart';
import 'package:enigma_web/src/e2_signal.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/known_exception.dart';
import 'package:enigma_web/src/operation_cancelled_exception.dart';
import 'package:enigma_web/src/parsers/helpers.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/parsers/parsing_exception.dart';
import 'package:enigma_web/src/responses/i_string_response.dart';
import 'package:enigma_web/src/responses/signal_response.dart';
import 'package:enigma_web/src/string_helper.dart';
import 'package:xml/xml.dart' as xml;

class SignalParser implements IResponseParser<ISignalCommand, SignalResponse> {
  @override
  Future<SignalResponse> parseAsync(
      IStringResponse response, EnigmaType enigmaType) async {
    try {
      if (enigmaType == EnigmaType.enigma1) {
        return await Future(() => parseE1(response));
      }

      return await Future(() => parseE2(response));
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }
      throw ParsingException('Failed to parse response\n$response',
          innerException: ex);
    }
  }

  SignalResponse parseE1(IStringResponse response) {
    var searchFor = 'type=\"checkbox\" value=\"';
    var responseString = response.responseString;
    var sLock = responseString
        .substring(responseString.indexOf(searchFor) + searchFor.length);
    sLock = sLock.substring(0, sLock.indexOf('\"'));
    var locked = (sLock.toLowerCase() == 'on');
    var sSync = responseString
        .substring(responseString.indexOf(searchFor) + searchFor.length);
    sSync = sSync.substring(sSync.indexOf(searchFor) + searchFor.length);
    sSync = sSync.substring(0, sSync.indexOf('\"'));
    var sync = (sSync.toLowerCase() == 'on');
    searchFor = '<td align=\"center\">';
    responseString = responseString
        .substring(responseString.indexOf(searchFor) + searchFor.length);
    var snr = responseString.substring(0, responseString.indexOf('%'));
    responseString = responseString
        .substring(responseString.indexOf(searchFor) + searchFor.length);
    var acg = responseString.substring(0, responseString.indexOf('%'));
    responseString = responseString
        .substring(responseString.indexOf(searchFor) + searchFor.length);

    var ber = responseString.substring(0, responseString.indexOf('<'));

    var signal = _initializeSignalEnigma1(snr, acg, ber, locked, sync);

    if (signal == null) {
      throw ParsingException('Failed to parse Enigma1 signal!');
    }

    return SignalResponse(signal, response.responseDuration);
  }

  E1Signal _initializeSignalEnigma1(
    String snr,
    String acg,
    String ber,
    bool locked,
    bool sync,
  ) {
    if (snr.isEmpty) {
      return E1Signal(
        snr: -1,
        acg: -1,
        ber: -1,
        lock: false,
        sync: false,
      );
    }

    return E1Signal(
      lock: locked,
      sync: sync,
      acg: int.parse(acg),
      snr: int.parse(snr),
      ber: int.parse(ber),
    );
  }

  SignalResponse parseE2(IStringResponse response) {
    var responseString = Helpers.sanitizeXmlString(response.responseString);

    String snr;
    String db;
    String acg;
    String ber;
    try {
      var document = xml.parse(responseString);

      var dbNodes = document.findAllElements('e2snrdb');
      if (dbNodes != null && dbNodes.isNotEmpty) {
        db = StringHelper.trimAll(dbNodes.first.text);
      }

      var snrNodes = document.findAllElements('e2snr');
      if (snrNodes != null && snrNodes.isNotEmpty) {
        snr = StringHelper.trimAll(snrNodes.first.text);
      }

      var berNodes = document.findAllElements('e2ber');
      if (berNodes != null && berNodes.isNotEmpty) {
        ber = StringHelper.trimAll(berNodes.first.text);
      }

      var acgNodes = document.findAllElements('e2acg');
      if (acgNodes != null && acgNodes.isNotEmpty) {
        acg = StringHelper.trimAll(acgNodes.first.text);
      }

      var signal = _initializeSignalEnigma2(snr, db, acg, ber);

      if (signal == null) {
        throw ParsingException('Failed to parse Enigma2 signal!');
      }

      return SignalResponse(signal, response.responseDuration);
    } on FormatException {
      throw ParsingException('Failed to parse E2 signal!\n$responseString');
    }
  }

  E2Signal _initializeSignalEnigma2(
    String snr,
    String db,
    String acg,
    String ber,
  ) {
    var ds = '.';
    String realSnr;
    String realDb;

    snr = StringHelper.trimAll(snr.replaceAll('%', ''));
    db = StringHelper.trimAll(
        StringHelper.trimAll(db.toLowerCase().replaceAll('db', ''))
            .replaceAll(',', ds)
            .replaceAll('.', ds));

    if (snr.isEmpty || db.isEmpty) {
      return E2Signal(
        db: -1,
        snr: -1,
        acg: -1,
        ber: -1,
      );
    }

    if (snr.toUpperCase().contains('N/A') || db.toUpperCase().contains('N/A')) {
      return E2Signal(
        db: -1,
        snr: -1,
        acg: -1,
        ber: -1,
      );
    }

    //dB is in percentage, someting is wrong
    if (db.contains('%')) {
      //if SNR is in dB we simply switch the values
      if (snr.contains('db')) {
        realSnr = db;
        realDb = snr;
        realDb = StringHelper.trimAll(realDb.replaceAll('db', ''))
            .replaceAll(',', ds)
            .replaceAll('.', ds);
        realSnr = StringHelper.trimAll(realSnr.replaceAll('%', ''));
      } else {
        //both dB and SNR are in %, we'll have to calculate dB
        realSnr = snr;
        realDb = null;
      }
    } else {
      realSnr = snr;
      realDb = db;
    }

    //check if snr value is in db
    if (snr.toLowerCase().contains('db')) {
      realSnr = null;
      realDb = db;
    }

    if (realSnr == null && realDb == null) {
      throw ParsingException('Failed to parse Enigma2 signal!');
    }

    int snr2;
    double db2;
    int acg2;
    int ber2;

    if (realSnr != null && realDb != null) {
      snr2 = int.parse(realSnr);
      db2 = double.parse(realDb);
    } else if (realDb != null) {
      db2 = double.parse(realDb);
      snr2 = (db2 * 6.5).round();
    } else {
      snr2 = int.parse(realSnr);
      db2 = double.parse((snr2 / 6.5).toStringAsFixed(2));
    }
    acg2 = int.parse(StringHelper.trimAll(acg.replaceAll('%', '')));
    ber2 = int.parse(StringHelper.trimAll(ber));
    return E2Signal(
      snr: snr2,
      db: db2,
      acg: acg2,
      ber: ber2,
    );
  }
}
