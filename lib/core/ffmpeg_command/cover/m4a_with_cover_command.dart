import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

class M4aWithCoverCommand implements ICommand {
  const M4aWithCoverCommand();

  @override
  List<String> get commands => [
    '-map',
    '0:v:0',

    '-vf',
    r'select=eq(n\,0)',

    '-c:v',
    'mjpeg',

    '-disposition:v:0',
    'attached_pic',
  ];
}

extension M4aWithCoverCommandX on AudioOutputFormat {
  M4aWithCoverCommand get m4aWithCoverCommand {
    return M4aWithCoverCommand();
  }
}
