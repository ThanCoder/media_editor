import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

class M4aFastCommand implements ICommand {
  const M4aFastCommand();
  @override
  List<String> get commands => ['-map', '0:a:0', '-c:a', 'copy'];
}

extension M4aFastCommandX on AudioOutputFormat {
  ICommand get m4aFastCommand {
    return const M4aFastCommand();
  }
}
