//import 'package:logging/logging.dart';
import 'package:xml/xml.dart' as xml;

import '../commands/i_signal_command.dart';
import '../enums.dart';
import '../i_e1_signal.dart';
import '../i_e2_signal.dart';
import '../i_factory.dart';
import '../known_exception.dart';
import '../operation_cancelled_exception.dart';
import '../parsers/helpers.dart';
import '../parsers/i_response_parser.dart';
import '../parsers/parsing_exception.dart';
import '../responses/i_signal_response.dart';
import '../string_helper.dart';

class SignalParser implements IResponseParser<ISignalCommand, ISignalResponse> {
  IFactory _factory;
  //Logger _log;

  SignalParser(IFactory factory) {
    if (factory == null) {
      throw ArgumentError.notNull("factory");
    }

    _factory = factory;
    //_log = factory.log;
  }

  @override
  Future<ISignalResponse> parseAsync(
      String response, EnigmaType enigmaType) async {
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

  ISignalResponse parseE1(String response) {
    String searchFor = "type=\"checkbox\" value=\"";
    String sLock =
        response.substring(response.indexOf(searchFor) + searchFor.length);
    sLock = sLock.substring(0, sLock.indexOf("\""));
    bool locked = (sLock.toLowerCase() == "on");
    String sSync =
        response.substring(response.indexOf(searchFor) + searchFor.length);
    sSync = sSync.substring(sSync.indexOf(searchFor) + searchFor.length);
    sSync = sSync.substring(0, sSync.indexOf("\""));
    bool sync = (sSync.toLowerCase() == "on");
    searchFor = "<td align=\"center\">";
    response =
        response.substring(response.indexOf(searchFor) + searchFor.length);
    String snr = response.substring(0, response.indexOf("%"));
    response =
        response.substring(response.indexOf(searchFor) + searchFor.length);
    String acg = response.substring(0, response.indexOf("%"));
    response =
        response.substring(response.indexOf(searchFor) + searchFor.length);

    String ber = response.substring(0, response.indexOf("<"));

    IE1Signal signal = _initializeSignal(snr, acg, ber, locked, sync);

    if (signal == null) {
      throw ParsingException("Failed to parse Enigma1 signal!");
    }

    return _factory.signalResponse(signal);
  }

  IE1Signal _initializeSignal(
      String snr, String acg, String ber, bool locked, bool sync) {
    IE1Signal signal = _factory.e1Signal();

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

  ISignalResponse parseE2(String response) {
    response = Helpers.sanitizeXmlString(response);

    String snr;
    String db;
    String acg;
    String ber;

    var document = xml.parse(response);

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

    IE2Signal signal = _initializeSignal1(snr, db, acg, ber);

    if (signal == null) {
      throw ParsingException("Failed to parse Enigma2 signal!");
    }

    return _factory.signalResponse(signal);
  }

  IE2Signal _initializeSignal1(String snr, String db, String acg, String ber) {
    IE2Signal signal = _factory.e2Signal();
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
    if (db.indexOf("%") > -1) {
      //if SNR is in dB we simply switch the values
      if (snr.indexOf("db") > -1) {
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
    if (snr.toLowerCase().indexOf("db") > -1) {
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
