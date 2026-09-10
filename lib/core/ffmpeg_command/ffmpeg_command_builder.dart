import 'package:media_editor/core/ffmpeg_command/i_command.dart';

class FfmpegCommandBuilder {
  const FfmpegCommandBuilder({
    required this.input,
    required this.output,
    required this.commands,
  });

  final String input;
  final String output;
  final List<ICommand> commands;

  String get command {
    return [
      '-i',
      '"$input"',

      for (final command in commands) ...command.commands,

      '-y',

      '"$output"',
    ].join(' ');
  }
}
