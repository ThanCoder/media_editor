import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

class OpusFastCommand implements ICommand {
  const OpusFastCommand();

  @override
  List<String> get commands => ['-map', '0:a:0', '-c:a', 'libopus'];
}

extension OpusFastCommandX on AudioOutputFormat {
  ICommand get opusFastCommand {
    return const OpusFastCommand();
  }
}
