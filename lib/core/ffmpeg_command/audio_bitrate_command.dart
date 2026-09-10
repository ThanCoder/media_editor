import 'package:media_editor/core/ffmpeg_command/i_command.dart';

class AudioBitrateCommand implements ICommand {
  const AudioBitrateCommand(this.bitrate);

  final int bitrate;

  @override
  List<String> get commands => ['-b:a', '${bitrate}k'];
}
