import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

class OggFastCommand implements ICommand {
  const OggFastCommand();

  @override
  List<String> get commands => ['-map', '0:a:0', '-c:a', 'libvorbis'];
}

extension OggFastCommandX on AudioOutputFormat {
  ICommand get oggFastCommand {
    return const OggFastCommand();
  }
}
