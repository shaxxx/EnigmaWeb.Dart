import 'package:enigma_web/src/enums.dart' show EnigmaType;

abstract class IProfile {
  String get name;
  String get username;
  String get password;
  EnigmaType get enigma;
  String get address;
  int get httpPort;
  bool get useSsl;
  int get streamingPort;
  bool get transcoding;
  int get transcodingPort;
  bool get streaming;
  String get id;
  Map<String, dynamic> toJson();
  IProfile.fromJson(Map<String, dynamic> json);
}
