import 'package:media_editor/platforms/pages/command_list_editor/types/command_plate.dart';

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
        id: 'output',
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
        id: 'start-end-time',
        title: 'Start-End Time',
        desc: 'Start-End converting from the specified time.',
        command: '-ss {start} -to {end}',
      ),

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
        id: 'volume',
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
        source: 'title',
      ),

      CommandPlateItem(
        id: 'Metadata-Artist',
        title: 'Artist',
        desc: 'Set the artist name.',
        command: '-metadata artist="{artist}"',
        source: 'artist',
      ),

      CommandPlateItem(
        id: 'Metadata-Album',
        title: 'Album',
        desc: 'Set the album name.',
        command: '-metadata album="{album}"',
        source: 'album',
      ),

      CommandPlateItem(
        id: 'Metadata-Genre',
        title: 'Genre',
        desc: 'Set the media genre.',
        command: '-metadata genre="{genre}"',
        source: 'genres',
      ),

      CommandPlateItem(
        id: 'Metadata-Year',
        title: 'Year',
        desc: 'Set the release year.',
        command: '-metadata date="{year}"',
        source: 'year',
      ),
      CommandPlateItem(
        id: 'Metadata-Comment',
        title: 'Comment',
        desc: 'Set the media comment metadata.',
        command: '-metadata comment="{comment}"',
        source: 'comment',
      ),

      CommandPlateItem(
        id: 'Metadata-Copy',
        title: 'Copy Metadata',
        desc: 'Copy metadata from the input file.',
        command: '-map_metadata 0',
      ),

      CommandPlateItem(
        id: 'Metadata-Clear',
        title: 'Remove Metadata',
        desc: 'Remove metadata from the output file.',
        command: '-map_metadata -1',
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
  CommandPlate(
    title: 'Stream',
    type: .stream,
    children: [
      CommandPlateItem(
        id: 'Stream-Audio-Only',
        title: 'Audio Only',
        desc: 'Keep only the audio stream and remove video streams.',
        command: '-map 0:a:0',
      ),

      CommandPlateItem(
        id: 'Stream-Video-Only',
        title: 'Video Only',
        desc: 'Keep only the video stream and remove audio streams.',
        command: '-map 0:v:0',
      ),

      CommandPlateItem(
        id: 'Stream-Copy-Audio',
        title: 'Copy Audio',
        desc: 'Copy the audio stream without re-encoding.',
        command: '-map 0:a:0 -c:a copy',
      ),

      CommandPlateItem(
        id: 'Stream-Copy-Video',
        title: 'Copy Video',
        desc: 'Copy the video stream without re-encoding.',
        command: '-map 0:v:0 -c:v copy',
      ),

      CommandPlateItem(
        id: 'Stream-Audio-Video',
        title: 'Audio + Video',
        desc: 'Keep both audio and video streams.',
        command: '-map 0:a:0 -map 0:v:0',
      ),

      CommandPlateItem(
        id: 'Stream-Copy-All',
        title: 'Copy All Streams',
        desc: 'Copy all input streams without re-encoding.',
        command: '-map 0 -c copy',
      ),
    ],
  ),
  CommandPlate(
    title: 'Other',
    type: .other,
    children: [
      .new(
        id: 'other-id-1',
        title: 'Other Command',
        desc: '',
        command: '{Custom Command}',
      ),
    ],
  ),
  CommandPlate(
    title: 'Video',
    type: .encode,
    children: [
      CommandPlateItem(
        id: 'Video-H264',
        title: 'H.264',
        desc: 'Encode video using H.264.',
        command: '-c:v libx264',
      ),

      CommandPlateItem(
        id: 'Video-H265',
        title: 'H.265 / HEVC',
        desc: 'Encode video using H.265/HEVC.',
        command: '-c:v libx265',
      ),

      CommandPlateItem(
        id: 'Video-VP9',
        title: 'VP9',
        desc: 'Encode video using VP9.',
        command: '-c:v libvpx-vp9',
      ),

      CommandPlateItem(
        id: 'Video-AV1',
        title: 'AV1',
        desc: 'Encode video using AV1.',
        command: '-c:v libaom-av1',
      ),

      CommandPlateItem(
        id: 'Video-Copy',
        title: 'Copy Video',
        desc: 'Copy the video stream without re-encoding.',
        command: '-c:v copy',
      ),

      CommandPlateItem(
        id: 'Video-CRF',
        title: 'CRF',
        desc: 'Set constant rate factor for video quality.',
        command: '-crf {crf}',
      ),

      CommandPlateItem(
        id: 'Video-Preset',
        title: 'Preset',
        desc: 'Set the encoder speed and compression preset.',
        command: '-preset {preset}',
      ),

      CommandPlateItem(
        id: 'Video-Bitrate',
        title: 'Video Bitrate',
        desc: 'Set the target video bitrate.',
        command: '-b:v {bitrate}',
      ),

      CommandPlateItem(
        id: 'Video-FPS',
        title: 'Frame Rate',
        desc: 'Change the video frame rate.',
        command: '-r {fps}',
      ),
    ],
  ),

  CommandPlate(
    title: 'Resolution',
    type: .encode,
    children: [
      CommandPlateItem(
        id: 'Resolution-720p',
        title: '720p',
        desc: 'Resize the video to 720p while preserving aspect ratio.',
        command: '-vf scale=-2:720',
      ),

      CommandPlateItem(
        id: 'Resolution-1080p',
        title: '1080p',
        desc: 'Resize the video to 1080p while preserving aspect ratio.',
        command: '-vf scale=-2:1080',
      ),

      CommandPlateItem(
        id: 'Resolution-480p',
        title: '480p',
        desc: 'Resize the video to 480p while preserving aspect ratio.',
        command: '-vf scale=-2:480',
      ),

      CommandPlateItem(
        id: 'Resolution-Custom',
        title: 'Custom Resolution',
        desc: 'Set a custom video width and height.',
        command: '-vf scale={width}:{height}',
      ),

      CommandPlateItem(
        id: 'Resolution-Width',
        title: 'Custom Width',
        desc: 'Set the video width and automatically preserve aspect ratio.',
        command: '-vf scale={width}:-2',
      ),

      CommandPlateItem(
        id: 'Resolution-Height',
        title: 'Custom Height',
        desc: 'Set the video height and automatically preserve aspect ratio.',
        command: '-vf scale=-2:{height}',
      ),
    ],
  ),

  CommandPlate(
    title: 'Audio',
    type: .encode,
    children: [
      CommandPlateItem(
        id: 'Audio-Sample-Rate',
        title: 'Sample Rate',
        desc: 'Change the audio sample rate.',
        command: '-ar {sample_rate}',
      ),

      CommandPlateItem(
        id: 'Audio-Channels-Mono',
        title: 'Mono',
        desc: 'Convert audio to mono.',
        command: '-ac 1',
      ),

      CommandPlateItem(
        id: 'Audio-Channels-Stereo',
        title: 'Stereo',
        desc: 'Convert audio to stereo.',
        command: '-ac 2',
      ),

      CommandPlateItem(
        id: 'Audio-Copy',
        title: 'Copy Audio',
        desc: 'Copy audio without re-encoding.',
        command: '-c:a copy',
      ),

      CommandPlateItem(
        id: 'Audio-Quality',
        title: 'Audio Quality',
        desc: 'Set audio quality for supported encoders.',
        command: '-q:a {quality}',
      ),
    ],
  ),

  CommandPlate(
    title: 'Filter',
    type: .other,
    children: [
      CommandPlateItem(
        id: 'Filter-Fade-In-Audio',
        title: 'Audio Fade In',
        desc: 'Gradually increase audio volume from silence.',
        command: '-af afade=t=in:st={start}:d={duration}',
      ),

      CommandPlateItem(
        id: 'Filter-Fade-Out-Audio',
        title: 'Audio Fade Out',
        desc: 'Gradually decrease audio volume to silence.',
        command: '-af afade=t=out:st={start}:d={duration}',
      ),

      CommandPlateItem(
        id: 'Filter-Fade-In-Video',
        title: 'Video Fade In',
        desc: 'Gradually fade the video in from black.',
        command: '-vf fade=t=in:st={start}:d={duration}',
      ),

      CommandPlateItem(
        id: 'Filter-Fade-Out-Video',
        title: 'Video Fade Out',
        desc: 'Gradually fade the video to black.',
        command: '-vf fade=t=out:st={start}:d={duration}',
      ),

      CommandPlateItem(
        id: 'Filter-Grayscale',
        title: 'Grayscale',
        desc: 'Convert the video to grayscale.',
        command: '-vf format=gray',
      ),

      CommandPlateItem(
        id: 'Filter-Brightness',
        title: 'Brightness',
        desc: 'Adjust video brightness.',
        command: '-vf eq=brightness={brightness}',
      ),

      CommandPlateItem(
        id: 'Filter-Contrast',
        title: 'Contrast',
        desc: 'Adjust video contrast.',
        command: '-vf eq=contrast={contrast}',
      ),

      CommandPlateItem(
        id: 'Filter-Saturation',
        title: 'Saturation',
        desc: 'Adjust video saturation.',
        command: '-vf eq=saturation={saturation}',
      ),

      CommandPlateItem(
        id: 'Filter-Sharpen',
        title: 'Sharpen',
        desc: 'Sharpen the video image.',
        command: '-vf unsharp',
      ),

      CommandPlateItem(
        id: 'Filter-Blur',
        title: 'Blur',
        desc: 'Apply a blur effect to the video.',
        command: '-vf boxblur={radius}',
      ),
    ],
  ),

  CommandPlate(
    title: 'Transform',
    type: .other,
    children: [
      CommandPlateItem(
        id: 'Transform-Rotate-90',
        title: 'Rotate 90°',
        desc: 'Rotate the video clockwise by 90 degrees.',
        command: '-vf transpose=1',
      ),

      CommandPlateItem(
        id: 'Transform-Rotate-270',
        title: 'Rotate 270°',
        desc: 'Rotate the video counter-clockwise by 90 degrees.',
        command: '-vf transpose=2',
      ),

      CommandPlateItem(
        id: 'Transform-Flip-Horizontal',
        title: 'Flip Horizontal',
        desc: 'Flip the video horizontally.',
        command: '-vf hflip',
      ),

      CommandPlateItem(
        id: 'Transform-Flip-Vertical',
        title: 'Flip Vertical',
        desc: 'Flip the video vertically.',
        command: '-vf vflip',
      ),

      CommandPlateItem(
        id: 'Transform-Crop',
        title: 'Crop',
        desc: 'Crop the video to a custom rectangle.',
        command: '-vf crop={width}:{height}:{x}:{y}',
      ),

      CommandPlateItem(
        id: 'Transform-Pad',
        title: 'Pad',
        desc: 'Add padding around the video.',
        command: '-vf pad={width}:{height}:{x}:{y}',
      ),
    ],
  ),

  CommandPlate(
    title: 'Subtitle',
    type: .other,
    children: [
      CommandPlateItem(
        id: 'Subtitle-Burn',
        title: 'Burn Subtitle',
        desc: 'Render subtitles directly into the video.',
        command: '-vf subtitles="{subtitle}"',
        source: 'subtitle',
      ),

      CommandPlateItem(
        id: 'Subtitle-Stream',
        title: 'Subtitle Stream',
        desc: 'Copy a subtitle stream into the output.',
        command: '-map 0:s:0',
      ),

      CommandPlateItem(
        id: 'Subtitle-Copy',
        title: 'Copy Subtitles',
        desc: 'Copy subtitle streams without re-encoding.',
        command: '-c:s copy',
      ),
    ],
  ),

  CommandPlate(
    title: 'Format',
    type: .output,
    children: [
      CommandPlateItem(
        id: 'Format-MP4',
        title: 'MP4',
        desc: 'Set MP4 as the output container format.',
        command: '-f mp4',
      ),

      CommandPlateItem(
        id: 'Format-MKV',
        title: 'MKV',
        desc: 'Set Matroska as the output container format.',
        command: '-f matroska',
      ),

      CommandPlateItem(
        id: 'Format-WebM',
        title: 'WebM',
        desc: 'Set WebM as the output container format.',
        command: '-f webm',
      ),

      CommandPlateItem(
        id: 'Format-MOV',
        title: 'MOV',
        desc: 'Set MOV as the output container format.',
        command: '-f mov',
      ),
    ],
  ),

  CommandPlate(
    title: 'Optimization',
    type: .other,
    children: [
      CommandPlateItem(
        id: 'Optimization-Faststart',
        title: 'Fast Start',
        desc: 'Move MP4 metadata to the beginning for faster streaming.',
        command: '-movflags +faststart',
      ),

      CommandPlateItem(
        id: 'Optimization-Threads',
        title: 'Threads',
        desc: 'Set the number of encoding threads.',
        command: '-threads {threads}',
      ),

      CommandPlateItem(
        id: 'Optimization-Shortest',
        title: 'Shortest',
        desc: 'Stop encoding when the shortest input stream ends.',
        command: '-shortest',
      ),
    ],
  ),

  CommandPlate(
    title: 'Advanced',
    type: .other,
    children: [
      CommandPlateItem(
        id: 'Advanced-Map',
        title: 'Map Stream',
        desc: 'Select a specific stream from the input.',
        command: '-map {map}',
      ),

      CommandPlateItem(
        id: 'Advanced-Disable-Video',
        title: 'Disable Video',
        desc: 'Disable video output.',
        command: '-vn',
      ),

      CommandPlateItem(
        id: 'Advanced-Disable-Audio',
        title: 'Disable Audio',
        desc: 'Disable audio output.',
        command: '-an',
      ),

      CommandPlateItem(
        id: 'Advanced-Disable-Subtitle',
        title: 'Disable Subtitle',
        desc: 'Disable subtitle output.',
        command: '-sn',
      ),

      CommandPlateItem(
        id: 'Advanced-Disable-Data',
        title: 'Disable Data',
        desc: 'Disable data streams.',
        command: '-dn',
      ),

      CommandPlateItem(
        id: 'Advanced-Loop',
        title: 'Loop Input',
        desc: 'Loop the input file.',
        command: '-stream_loop {count}',
      ),

      CommandPlateItem(
        id: 'Advanced-Shortest',
        title: 'Shortest',
        desc: 'Finish when the shortest stream ends.',
        command: '-shortest',
      ),
    ],
  ),
];
