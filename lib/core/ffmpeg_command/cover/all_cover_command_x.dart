import 'package:media_editor/core/ffmpeg_command/cover/flac_with_cover_command.dart';
import 'package:media_editor/core/ffmpeg_command/cover/m4a_with_cover_command.dart';
import 'package:media_editor/core/ffmpeg_command/cover/mp3_with_cover_command.dart';
import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/types/audio_output_format.dart';

extension AllCoverCommandX on AudioOutputFormat {
  ICommand? get coverCommand {
    return switch (this) {
      AudioOutputFormat.mp3 => mp3WithCoverCommand,
      AudioOutputFormat.m4a => m4aWithCoverCommand,
      AudioOutputFormat.flac => flacWithCoverCommand,
      _ => null,
    };
  }
}
