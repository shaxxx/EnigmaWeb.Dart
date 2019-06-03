import 'enums.dart' show EnigmaType;
import 'i_profile.dart';

class Profile implements IProfile {
  @override
  String address;
  @override
  EnigmaType enigma = EnigmaType.enigma1;
  @override
  int httpPort = 0;
  @override
  String name;
  @override
  String password;
  @override
  bool useSsl = false;
  @override
  String username;
  @override
  int streamingPort = 0;

  Profile() {
    name = "";
    username = "root";
    password = "dreambox";
    address = "192.168.1.1";
    enigma = EnigmaType.enigma2;
    httpPort = 80;
  }

  @override
  String toString() {
    return name;
  }
}
