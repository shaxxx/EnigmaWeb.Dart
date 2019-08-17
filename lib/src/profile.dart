import 'package:enigma_web/src/i_profile.dart';

import 'enums.dart' show EnigmaType;

class Profile implements IProfile {
  final String address;
  final EnigmaType enigma;
  final int httpPort;
  final String name;
  final String password;
  final bool useSsl;
  final String username;
  final int streamingPort;
  final bool transcoding;
  final int transcodingPort;
  final bool streaming;

  Profile({
    this.address,
    this.enigma = EnigmaType.enigma2,
    this.httpPort = 80,
    this.name,
    this.password = 'dreambox',
    this.useSsl = false,
    this.username = 'root',
    this.streamingPort,
    this.transcoding = false,
    this.transcodingPort,
    this.streaming,
  })  : assert(address != null),
        assert(address.length > 0),
        assert(enigma != null),
        assert(httpPort != null),
        assert(name != null),
        assert(password != null),
        assert(useSsl != null),
        assert(username != null),
        assert(transcoding != null),
        assert(streaming != null);

  @override
  int get hashCode => name.hashCode ^
              username.hashCode ^
              password.hashCode ^
              enigma.hashCode ^
              address.hashCode ^
              httpPort.hashCode ^
              useSsl.hashCode ^
              streamingPort ==
          null
      ? 0
      : streamingPort.hashCode ^ transcodingPort == null
          ? 0
          : transcodingPort.hashCode ^
              transcoding.hashCode ^
              streaming.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IProfile &&
          runtimeType == other.runtimeType &&
          transcodingPort == other.transcodingPort &&
          transcoding == other.transcoding &&
          streaming == other.streaming &&
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
