import 'package:media_editor/platforms/pages/command_list_editor/command_plate.dart';

const commandPlateData = [
  CommandPlate(
    title: 'Input',
    type: .input,
    children: [
      CommandPlateItem(
        id: 'Input-Video-File',
        title: 'Input Video File',
        desc: 'Select the input video file.',
        command: '-i "{input}"',
      ),
      CommandPlateItem(
        id: 'Input-Audio-File',
        title: 'Input Audio File',
        desc: 'Select the input audio file.',
        command: '-i "{input}"',
      ),
    ],
  ),

  CommandPlate(
    title: 'Output',
    type: .output,
    children: [
      CommandPlateItem(
        id: 'Output-File',
        title: 'Output File',
        desc: 'Set the output file path.',
        command: '"{output}"',
      ),

      CommandPlateItem(
        id: 'Overwrite',
        title: 'Overwrite',
        desc: 'Overwrite the output file if it already exists.',
        command: '-y',
      ),
    ],
  ),

  CommandPlate(
    title: 'Trim',
    type: .trim,
    children: [
      CommandPlateItem(
        id: 'start-time',
        title: 'Start Time',
        desc: 'Start converting from the specified time.',
        command: '-ss {start}',
      ),

      CommandPlateItem(
        id: 'duration',
        title: 'Duration',
        desc: 'Convert for the specified duration.',
        command: '-t {duration}',
      ),

      CommandPlateItem(
        id: 'End-Time',
        title: 'End Time',
        desc: 'Stop converting at the specified time.',
        command: '-to {end}',
      ),
    ],
  ),

  CommandPlate(
    title: 'Volume',
    type: .volume,
    children: [
      CommandPlateItem(
        id: 'Volume',
        title: 'Volume',
        desc: 'Change the audio volume.',
        command: '-af volume={volume}',
      ),
      CommandPlateItem(
        id: 'Volume-200',
        title: 'Volume 200%',
        desc: 'Change the audio volume. 200%',
        command: '-af volume=2',
      ),

      CommandPlateItem(
        id: 'Mute',
        title: 'Mute',
        desc: 'Mute the audio output.',
        command: '-af volume=0',
      ),
    ],
  ),

  CommandPlate(
    title: 'Metadata',
    type: .metadata,
    children: [
      CommandPlateItem(
        id: 'Metadata-Title',
        title: 'Title',
        desc: 'Set the media title.',
        command: '-metadata title="{title}"',
      ),

      CommandPlateItem(
        id: 'Metadata-Artist',
        title: 'Artist',
        desc: 'Set the artist name.',
        command: '-metadata artist="{artist}"',
      ),

      CommandPlateItem(
        id: 'Metadata-Album',
        title: 'Album',
        desc: 'Set the album name.',
        command: '-metadata album="{album}"',
      ),

      CommandPlateItem(
        id: 'Metadata-Genre',
        title: 'Genre',
        desc: 'Set the media genre.',
        command: '-metadata genre="{genre}"',
      ),

      CommandPlateItem(
        id: 'Metadata-Year',
        title: 'Year',
        desc: 'Set the release year.',
        command: '-metadata date="{year}"',
      ),
    ],
  ),

  CommandPlate(
    title: 'Cover',
    type: .cover,
    children: [
      CommandPlateItem(
        id: 'Cover-Copy-Embedded-Cover',
        title: 'Copy Embedded Cover',
        desc: 'Copy an existing attached picture when supported.',
        command:
            '-map 0:a:0 -map 0:v:0 -c:v copy -disposition:v:0 attached_pic',
      ),

      CommandPlateItem(
        id: 'Cover-Extract-Video-Frame',
        title: 'Extract Video Frame',
        desc: 'Use the first video frame as cover art.',
        command: '-map 0:a:0 -map 0:v:0 -frames:v 1 -c:v mjpeg -disposition:v:0 attached_pic',
      ),
    ],
  ),

  CommandPlate(
    title: 'Encode',
    type: .encode,
    children: [
      CommandPlateItem(
        id: 'Encode-AAC',
        title: 'AAC',
        desc: 'Encode audio using AAC.',
        command: '-c:a aac',
      ),

      CommandPlateItem(
        id: 'Encode-MP3',
        title: 'MP3',
        desc: 'Encode audio using the MP3 encoder.',
        command: '-c:a libmp3lame',
      ),

      CommandPlateItem(
        id: 'Encode-Opus',
        title: 'Opus',
        desc: 'Encode audio using Opus.',
        command: '-c:a libopus',
      ),

      CommandPlateItem(
        id: 'Encode-FLAC',
        title: 'FLAC',
        desc: 'Encode audio using FLAC lossless compression.',
        command: '-c:a flac',
      ),

      CommandPlateItem(
        id: 'Encode-Vorbis',
        title: 'Vorbis',
        desc: 'Encode audio using Vorbis.',
        command: '-c:a libvorbis',
      ),

      CommandPlateItem(
        id: 'Encode-WAV',
        title: 'WAV',
        desc: 'Encode audio as PCM.',
        command: '-c:a pcm_s16le',
      ),

      CommandPlateItem(
        id: 'Encode-Copy-Audio',
        title: 'Copy Audio',
        desc: 'Copy the audio stream without re-encoding.',
        command: '-c:a copy',
      ),

      CommandPlateItem(
        id: 'Encode-Audio-Bitrate',
        title: 'Audio Bitrate',
        desc: 'Set the audio bitrate.',
        command: '-b:a {bitrate}',
      ),
    ],
  ),
];
