import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

class Mp3FastCommand implements ICommand {
  const Mp3FastCommand();

  @override
  List<String> get commands => ['-map', '0:a:0', '-c:a', 'libmp3lame'];
}

extension Mp3FastCommandX on AudioOutputFormat {
  ICommand get mp3FastCommand {
    return const Mp3FastCommand();
  }
}
