enum MessageType { question, info, message, warning }
enum ReloadSettingsType { all, services, bouquets }

class EnigmaType {
  final int value;
  final String name;
  const EnigmaType._(this.value, this.name);

  static const enigma1 = EnigmaType._(0, 'Enigma1');
  static const enigma2 = EnigmaType._(1, 'Enigma2');

  static const List<EnigmaType> values = [
    enigma1,
    enigma2,
  ];

  @override
  int get hashCode => name.hashCode ^ value.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnigmaType &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          value == other.value;

  @override
  String toString() {
    return name;
  }
}

class ScreenshotType {
  final int value;
  final String name;
  const ScreenshotType._(this.value, this.name);

  static const all = ScreenshotType._(1, 'All');
  static const picture = ScreenshotType._(2, 'Picture');
  static const osd = ScreenshotType._(3, 'Osd');

  static const List<ScreenshotType> values = [
    all,
    picture,
    osd,
  ];

  @override
  int get hashCode => name.hashCode ^ value.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnigmaType &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          value == other.value;

  @override
  String toString() {
    return name;
  }
}

class RemoteControlCode {
  final int value;
  final String name;
  const RemoteControlCode._(this.value, this.name);

  static const power = RemoteControlCode._(116, 'Power');
  static const key1 = RemoteControlCode._(2, 'Key1');
  static const key2 = RemoteControlCode._(3, 'Key2');
  static const key3 = RemoteControlCode._(4, 'Key3');
  static const key4 = RemoteControlCode._(5, 'Key4');
  static const key5 = RemoteControlCode._(6, 'Key5');
  static const key6 = RemoteControlCode._(7, 'Key6');
  static const key7 = RemoteControlCode._(8, 'Key7');
  static const key8 = RemoteControlCode._(9, 'Key8');
  static const key9 = RemoteControlCode._(10, 'Key9');
  static const key0 = RemoteControlCode._(11, 'Key0');
  static const volumeUp = RemoteControlCode._(115, 'VolumeUp');
  static const volumeDown = RemoteControlCode._(114, 'VolumeDown');
  static const previous = RemoteControlCode._(412, 'Previous');
  static const keyNext = RemoteControlCode._(407, 'KeyNext');
  static const mute = RemoteControlCode._(113, 'Mute');
  static const bouquetUp = RemoteControlCode._(402, 'BouquetUp');
  static const bouquetDown = RemoteControlCode._(403, 'NouquetDown');
  static const lame = RemoteControlCode._(1, 'Lame');
  static const info = RemoteControlCode._(358, 'Info');
  static const up = RemoteControlCode._(103, 'Up');
  static const dream = RemoteControlCode._(141, 'Dream');
  static const left = RemoteControlCode._(105, 'Left');
  static const right = RemoteControlCode._(106, 'Right');
  static const ok = RemoteControlCode._(352, 'Ok');
  static const audio = RemoteControlCode._(392, 'Audio');
  static const down = RemoteControlCode._(108, 'Down');
  static const video = RemoteControlCode._(393, 'Video');
  static const red = RemoteControlCode._(398, 'Red');
  static const green = RemoteControlCode._(399, 'Green');
  static const yellow = RemoteControlCode._(400, 'Yellow');
  static const blue = RemoteControlCode._(401, 'Blue');
  static const tv = RemoteControlCode._(385, 'Tv');
  static const radio = RemoteControlCode._(377, 'Radio');
  static const text = RemoteControlCode._(66, 'Text');
  static const help = RemoteControlCode._(138, 'Help');

  static const List<RemoteControlCode> values = [
    power,
    key1,
    key2,
    key3,
    key4,
    key5,
    key6,
    key7,
    key8,
    key9,
    key0,
    volumeUp,
    volumeDown,
    previous,
    keyNext,
    mute,
    bouquetUp,
    bouquetDown,
    lame,
    info,
    up,
    dream,
    left,
    right,
    ok,
    audio,
    down,
    video,
    red,
    green,
    yellow,
    blue,
    tv,
    radio,
    text,
    help,
  ];

  @override
  int get hashCode => name.hashCode ^ value.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnigmaType &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          value == other.value;

  @override
  String toString() {
    return name;
  }
}
