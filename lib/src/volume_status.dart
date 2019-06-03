import 'i_volume_status.dart';

class VolumeStatus implements IVolumeStatus {
  @override
  int level;

  @override
  bool mute = false;
}
