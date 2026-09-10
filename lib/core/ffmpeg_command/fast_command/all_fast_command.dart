import 'package:media_editor/core/ffmpeg_command/fast_command/aac_fast_command.dart';
import 'package:media_editor/core/ffmpeg_command/fast_command/flac_fast_command.dart';
import 'package:media_editor/core/ffmpeg_command/fast_command/m4a_fast_command.dart';
import 'package:media_editor/core/ffmpeg_command/fast_command/mp3_fast_command.dart';
import 'package:media_editor/core/ffmpeg_command/fast_command/ogg_fast_command.dart';
import 'package:media_editor/core/ffmpeg_command/fast_command/opus_fast_command.dart';
import 'package:media_editor/core/ffmpeg_command/fast_command/wav_fast_command.dart';
import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

extension AllFastCommandX on AudioOutputFormat {
  ICommand get fastCommand {
    return switch (this) {
      .aac => aacFastCommand,
      .flac => flacFastCommand,
      .m4a => m4aFastCommand,
      .mp3 => mp3FastCommand,
      .ogg => oggFastCommand,
      .opus => opusFastCommand,
      .wav => wavFastCommand,
    };
  }
}
