import 'package:enigma_web/src/i_profile.dart';

import 'enums.dart' show EnigmaType;

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
  int get hashCode =>
      name.hashCode ^
      username.hashCode ^
      password.hashCode ^
      enigma.hashCode ^
      address.hashCode ^
      httpPort.hashCode ^
      useSsl.hashCode ^
      streamingPort.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IProfile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          username == other.username &&
          password == other.password &&
          enigma == other.enigma &&
          address == other.address &&
          httpPort == other.httpPort &&
          useSsl == other.useSsl &&
          streamingPort == other.streamingPort;

  @override
  String toString() {
    return 'Profile $name, address $address, port: $httpPort, enigma: $enigma';
  }
}
