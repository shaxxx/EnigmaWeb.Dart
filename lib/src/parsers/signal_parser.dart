//import 'package:logging/logging.dart';
import 'package:enigma_web/src/commands/i_signal_command.dart';
import 'package:enigma_web/src/e1_signal.dart';
import 'package:enigma_web/src/e2_signal.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_e1_signal.dart';
import 'package:enigma_web/src/i_e2_signal.dart';
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
      throw ParsingException.withException(
          "Failed to parse response\n$response", ex);
    }
  }

  SignalResponse parseE1(IStringResponse response) {
    String searchFor = "type=\"checkbox\" value=\"";
    var responseString = response.responseString;
    String sLock = responseString
        .substring(responseString.indexOf(searchFor) + searchFor.length);
    sLock = sLock.substring(0, sLock.indexOf("\""));
    bool locked = (sLock.toLowerCase() == "on");
    String sSync = responseString
        .substring(responseString.indexOf(searchFor) + searchFor.length);
    sSync = sSync.substring(sSync.indexOf(searchFor) + searchFor.length);
    sSync = sSync.substring(0, sSync.indexOf("\""));
    bool sync = (sSync.toLowerCase() == "on");
    searchFor = "<td align=\"center\">";
    responseString = responseString
        .substring(responseString.indexOf(searchFor) + searchFor.length);
    String snr = responseString.substring(0, responseString.indexOf("%"));
    responseString = responseString
        .substring(responseString.indexOf(searchFor) + searchFor.length);
    String acg = responseString.substring(0, responseString.indexOf("%"));
    responseString = responseString
        .substring(responseString.indexOf(searchFor) + searchFor.length);

    String ber = responseString.substring(0, responseString.indexOf("<"));

    var signal = _initializeSignal(snr, acg, ber, locked, sync);

    if (signal == null) {
      throw ParsingException("Failed to parse Enigma1 signal!");
    }

    return SignalResponse(signal, response.responseDuration);
  }

  E1Signal _initializeSignal(
      String snr, String acg, String ber, bool locked, bool sync) {
    IE1Signal signal = E1Signal();

    if (snr.isEmpty) {
      signal.snr = -1;
      signal.acg = -1;
      signal.ber = -1;
      return signal;
    }

    signal.lock = locked;
    signal.sync = sync;
    signal.acg = int.parse(acg);
    signal.snr = int.parse(snr);
    signal.ber = int.parse(ber);

    return signal;
  }

  SignalResponse parseE2(IStringResponse response) {
    var responseString = Helpers.sanitizeXmlString(response.responseString);

    String snr;
    String db;
    String acg;
    String ber;

    var document = xml.parse(responseString);

    var dbNodes = document.findAllElements("e2snrdb");
    if (dbNodes != null && dbNodes.isNotEmpty) {
      db = StringHelper.trimAll(dbNodes.first.text);
    }

    var snrNodes = document.findAllElements("e2snr");
    if (snrNodes != null && snrNodes.isNotEmpty) {
      snr = StringHelper.trimAll(snrNodes.first.text);
    }

    var berNodes = document.findAllElements("e2ber");
    if (berNodes != null && berNodes.isNotEmpty) {
      ber = StringHelper.trimAll(berNodes.first.text);
    }

    var acgNodes = document.findAllElements("e2acg");
    if (acgNodes != null && acgNodes.isNotEmpty) {
      acg = StringHelper.trimAll(acgNodes.first.text);
    }

    var signal = _initializeSignal1(snr, db, acg, ber);

    if (signal == null) {
      throw ParsingException("Failed to parse Enigma2 signal!");
    }

    return SignalResponse(signal, response.responseDuration);
  }

  E2Signal _initializeSignal1(String snr, String db, String acg, String ber) {
    IE2Signal signal = E2Signal();
    String ds = ".";

    String realSnr;
    String realDb;

    snr = StringHelper.trimAll(snr.replaceAll("%", ""));
    db = StringHelper.trimAll(
        StringHelper.trimAll(db.toLowerCase().replaceAll("db", ""))
            .replaceAll(",", ds)
            .replaceAll(".", ds));

    if (snr.isEmpty || db.isEmpty) {
      signal.db = -1;
      signal.snr = -1;
      signal.acg = -1;
      signal.ber = -1;
      return signal;
    }

    //dB is in percentage, someting is wrong
    if (db.contains("%")) {
      //if SNR is in dB we simply switch the values
      if (snr.contains("db")) {
        realSnr = db;
        realDb = snr;
        realDb = StringHelper.trimAll(realDb.replaceAll("db", ""))
            .replaceAll(",", ds)
            .replaceAll(".", ds);
        realSnr = StringHelper.trimAll(realSnr.replaceAll("%", ""));
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
    if (snr.toLowerCase().contains("db")) {
      realSnr = null;
      realDb = db;
    }

    if (realSnr == null && realDb == null) {
      throw ParsingException("Failed to parse Enigma2 signal!");
    }

    if (realSnr != null && realDb != null) {
      signal.snr = int.parse(realSnr);
      signal.db = double.parse(realDb);
    } else if (realDb != null) {
      signal.db = double.parse(realDb);
      signal.snr = (signal.db * 6.5).round();
    } else {
      signal.snr = int.parse(realSnr);
      signal.db = double.parse((signal.snr / 6.5).toStringAsFixed(2));
    }
    signal.acg = int.parse(StringHelper.trimAll(acg.replaceAll("%", "")));
    signal.ber = int.parse(StringHelper.trimAll(ber));
    return signal;
  }
}
