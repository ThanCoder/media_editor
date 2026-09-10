import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

class AacFastCommand implements ICommand {
  const AacFastCommand();

  @override
  List<String> get commands => [
    '-map',
    '0:a:0',
    '-c:a',
    'aac',
  ];
}

extension AacFastCommandX on AudioOutputFormat {
  ICommand get aacFastCommand {
    return const AacFastCommand();
  }
}