import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

class WavFastCommand implements ICommand {
  const WavFastCommand();

  @override
  List<String> get commands => ['-map', '0:a:0', '-c:a', 'pcm_s16le'];
}

extension WavFastCommandX on AudioOutputFormat {
  ICommand get wavFastCommand {
    return const WavFastCommand();
  }
}
