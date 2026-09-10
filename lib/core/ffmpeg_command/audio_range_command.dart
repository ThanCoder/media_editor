import 'package:media_editor/core/ffmpeg_command/i_command.dart';

class AudioRangeCommand implements ICommand {
  const AudioRangeCommand({this.start, this.end});

  final Duration? start;
  final Duration? end;

  @override
  List<String> get commands => [
    if (start != null) ...['-ss', _formatDuration(start!)],
    if (end != null) ...['-to', _formatDuration(end!)],
  ];

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }
}
