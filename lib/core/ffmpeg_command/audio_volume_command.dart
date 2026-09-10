import 'package:media_editor/core/ffmpeg_command/i_command.dart';

class AudioVolumeCommand implements ICommand {
  const AudioVolumeCommand(this.volume);

  final double volume;

  @override
  List<String> get commands => ['-af', 'volume=$volume'];
}
