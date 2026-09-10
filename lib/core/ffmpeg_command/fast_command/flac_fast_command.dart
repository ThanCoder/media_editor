import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

class FlacFastCommand implements ICommand {
  const FlacFastCommand();

  @override
  List<String> get commands => ['-map', '0:a:0', '-c:a', 'flac'];
}

extension FlacFastCommandX on AudioOutputFormat {
  ICommand get flacFastCommand {
    return const FlacFastCommand();
  }
}
