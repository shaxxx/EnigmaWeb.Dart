import 'enums.dart' show EnigmaType;

abstract class IProfile {
  String name;
  String username;
  String password;
  EnigmaType enigma = EnigmaType.enigma2;
  String address;
  int httpPort = 0;
  bool useSsl = false;
  int streamingPort = 0;
}
