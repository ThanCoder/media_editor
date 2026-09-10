import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

class AudioCodecCommand implements ICommand {
  const AudioCodecCommand(this.codec);

  final String codec;

  @override
  List<String> get commands => ['-map', '0:a:0', '-c:a', codec];
}

extension AudioCodecCommandX on AudioOutputFormat {
  ICommand get codecCommand {
    return AudioCodecCommand(codec);
  }
}
