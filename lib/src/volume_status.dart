import 'package:enigma_web/src/i_volume_status.dart';

class VolumeStatus implements IVolumeStatus {
  @override
  int level;

  @override
  bool mute = false;

  @override
  int get hashCode => level.hashCode ^ mute.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VolumeStatus && runtimeType == other.runtimeType && level == other.level && mute == other.mute;

  @override
  String toString() {
    return 'Volume level: $level, mute: $mute';
  }
}
