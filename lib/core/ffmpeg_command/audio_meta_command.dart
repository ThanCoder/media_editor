import 'package:media_editor/core/ffmpeg_command/i_command.dart';

class AudioMetadataCommand implements ICommand {
  const AudioMetadataCommand({
    this.title,
    this.artist,
    this.album,
    this.genre,
    this.date,
  });

  final String? title;
  final String? artist;
  final String? album;
  final String? genre;
  final String? date;

  @override
  List<String> get commands => [
    if (title?.isNotEmpty ?? false) ...['-metadata', 'title="$title"'],
    if (artist?.isNotEmpty ?? false) ...['-metadata', 'artist="$artist"'],
    if (album?.isNotEmpty ?? false) ...['-metadata', 'album="$album"'],
    if (genre?.isNotEmpty ?? false) ...['-metadata', 'genre="$genre"'],
    if (date?.isNotEmpty ?? false) ...['-metadata', 'date="$date"'],
  ];
}
