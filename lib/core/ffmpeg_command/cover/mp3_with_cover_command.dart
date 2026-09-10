import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

class Mp3WithCoverCommand implements ICommand {
  const Mp3WithCoverCommand();

  @override
  List<String> get commands => [
    '-map',
    '0:a:0',
    '-map',
    '0:v:0',

    '-c:a',
    'libmp3lame',

    '-c:v',
    'mjpeg',

    '-frames:v',
    '1',

    '-id3v2_version',
    '3',

    '-metadata:s:v',
    'title=Album cover',

    '-metadata:s:v',
    'comment=Cover (Front)',

    '-disposition:v:0',
    'attached_pic',
  ];
}

extension Mp3WithCoverCommandX on AudioOutputFormat {
  Mp3WithCoverCommand get mp3WithCoverCommand {
    assert(this == AudioOutputFormat.mp3);

    return const Mp3WithCoverCommand();
  }
}