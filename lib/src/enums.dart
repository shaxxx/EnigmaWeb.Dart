enum MessageType { Question, Info, Message, Warning }
enum ReloadSettingsType { All, Services, Bouquets }

class EnigmaType {
  final int value;
  final String name;
  const EnigmaType._(this.value, this.name);

  static const enigma1 = const EnigmaType._(1, 'Enigma1');
  static const enigma2 = const EnigmaType._(2, 'Enigma2');

  static const List<EnigmaType> values = [
    enigma1,
    enigma2,
  ];

  @override
  String toString() => name;
}

class ScreenshotType {
  final int value;
  final String name;
  const ScreenshotType._(this.value, this.name);

  static const all = const ScreenshotType._(1, 'All');
  static const picture = const ScreenshotType._(2, 'Picture');
  static const osd = const ScreenshotType._(3, 'Osd');

  static const List<ScreenshotType> values = [
    all,
    picture,
    osd,
  ];

  @override
  String toString() => name;
}

class RemoteControlCode {
  final int value;
  final String name;
  const RemoteControlCode._(this.value, this.name);

  static const power = const RemoteControlCode._(116, 'Power');
  static const key1 = const RemoteControlCode._(2, 'Key1');
  static const key2 = const RemoteControlCode._(3, 'Key2');
  static const key3 = const RemoteControlCode._(4, 'Key3');
  static const key4 = const RemoteControlCode._(5, 'Key4');
  static const key5 = const RemoteControlCode._(6, 'Key5');
  static const key6 = const RemoteControlCode._(7, 'Key6');
  static const key7 = const RemoteControlCode._(8, 'Key7');
  static const key8 = const RemoteControlCode._(9, 'Key8');
  static const key9 = const RemoteControlCode._(10, 'Key9');
  static const key0 = const RemoteControlCode._(11, 'Key0');
  static const volumeUp = const RemoteControlCode._(115, 'VolumeUp');
  static const volumeDown = const RemoteControlCode._(114, 'VolumeDown');
  static const previous = const RemoteControlCode._(412, 'Previous');
  static const keyNext = const RemoteControlCode._(407, 'KeyNext');
  static const mute = const RemoteControlCode._(113, 'Mute');
  static const bouquetUp = const RemoteControlCode._(402, 'BouquetUp');
  static const bouquetDown = const RemoteControlCode._(403, 'NouquetDown');
  static const lame = const RemoteControlCode._(1, 'Lame');
  static const info = const RemoteControlCode._(358, 'Info');
  static const up = const RemoteControlCode._(103, 'Up');
  static const dream = const RemoteControlCode._(141, 'Dream');
  static const left = const RemoteControlCode._(105, 'Left');
  static const right = const RemoteControlCode._(106, 'Right');
  static const ok = const RemoteControlCode._(352, 'Ok');
  static const audio = const RemoteControlCode._(392, 'Audio');
  static const down = const RemoteControlCode._(108, 'Down');
  static const video = const RemoteControlCode._(393, 'Video');
  static const red = const RemoteControlCode._(398, 'Red');
  static const green = const RemoteControlCode._(399, 'Green');
  static const yellow = const RemoteControlCode._(400, 'Yellow');
  static const blue = const RemoteControlCode._(401, 'Blue');
  static const tv = const RemoteControlCode._(385, 'Tv');
  static const radio = const RemoteControlCode._(377, 'Radio');
  static const text = const RemoteControlCode._(66, 'Text');
  static const help = const RemoteControlCode._(138, 'Help');

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
  String toString() => name;
}
