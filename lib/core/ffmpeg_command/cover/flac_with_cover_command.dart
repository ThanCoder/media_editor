import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

// -map 0:a:0
// -map 0:v:0
// -c:a flac
// -c:v mjpeg
// -frames:v 1
// -disposition:v:0 attached_pic
class FlacWithCoverCommand implements ICommand {
  const FlacWithCoverCommand();

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

extension FlacWithCoverCommandX on AudioOutputFormat {
  FlacWithCoverCommand get flacWithCoverCommand {
    assert(this == AudioOutputFormat.flac);

    return const FlacWithCoverCommand();
  }
}
