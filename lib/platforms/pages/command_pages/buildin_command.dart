class FFmpegCustomCommand {
  final String title;
  final String command;
  final String description;

  const FFmpegCustomCommand({
    required this.title,
    required this.command,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'command': command,
      'description': description,
    };
  }

  factory FFmpegCustomCommand.fromMap(Map<String, dynamic> map) {
    return FFmpegCustomCommand(
      title: map['title'] as String,
      command: map['command'] as String,
      description: map['description'] as String,
    );
  }
}

final List<FFmpegCustomCommand> buildInFFmpegCommands = [
  // Fast conversion

  const FFmpegCustomCommand(
    title: 'Fast Convert (Stream Copy)',
    command: '-c copy',
    description:
        'Repackage without re-encoding. Very fast and keeps original quality.',
  ),

  const FFmpegCustomCommand(
    title: 'Copy Video',
    command: '-c:v copy',
    description: 'Copy the video stream without re-encoding.',
  ),

  const FFmpegCustomCommand(
    title: 'Copy Audio',
    command: '-c:a copy',
    description: 'Copy the audio stream without re-encoding.',
  ),

  // Stream selection
  const FFmpegCustomCommand(
    title: 'Video Only',
    command: '-map 0:v:0 -an',
    description: 'Keep only the first video stream and remove audio.',
  ),

  const FFmpegCustomCommand(
    title: 'Audio Only',
    command: '-map 0:a:0 -vn',
    description: 'Keep only the first audio stream and remove video.',
  ),

  const FFmpegCustomCommand(
    title: 'First Video Stream',
    command: '-map 0:v:0',
    description: 'Select only the first video stream.',
  ),

  const FFmpegCustomCommand(
    title: 'First Audio Stream',
    command: '-map 0:a:0',
    description: 'Select only the first audio stream.',
  ),

  // Video codecs
  const FFmpegCustomCommand(
    title: 'H.264 Video',
    command: '-c:v libx264',
    description: 'Encode the video using H.264.',
  ),

  const FFmpegCustomCommand(
    title: 'H.265 / HEVC',
    command: '-c:v libx265',
    description: 'Encode the video using H.265 / HEVC.',
  ),

  const FFmpegCustomCommand(
    title: 'H.264 + AAC',
    command: '-c:v libx264 -c:a aac',
    description: 'Convert video to H.264 and audio to AAC.',
  ),

  const FFmpegCustomCommand(
    title: 'Copy Video + AAC Audio',
    command: '-c:v copy -c:a aac',
    description: 'Copy the original video and convert audio to AAC.',
  ),

  const FFmpegCustomCommand(
    title: 'Copy Video + Copy Audio',
    command: '-c:v copy -c:a copy',
    description: 'Copy video and audio streams without re-encoding.',
  ),

  // Audio codecs
  const FFmpegCustomCommand(
    title: 'AAC Audio',
    command: '-c:a aac',
    description: 'Encode audio using AAC.',
  ),

  const FFmpegCustomCommand(
    title: 'MP3 Audio',
    command: '-c:a libmp3lame',
    description: 'Encode audio using the MP3 encoder.',
  ),

  const FFmpegCustomCommand(
    title: 'Opus Audio',
    command: '-c:a libopus',
    description: 'Encode audio using Opus.',
  ),

  const FFmpegCustomCommand(
    title: 'Vorbis Audio',
    command: '-c:a libvorbis',
    description: 'Encode audio using Vorbis.',
  ),

  const FFmpegCustomCommand(
    title: 'FLAC Audio',
    command: '-c:a flac',
    description: 'Encode audio using lossless FLAC.',
  ),

  const FFmpegCustomCommand(
    title: 'WAV PCM',
    command: '-c:a pcm_s16le',
    description: 'Encode audio as uncompressed PCM.',
  ),

  // Remove streams
  const FFmpegCustomCommand(
    title: 'Remove Audio',
    command: '-an',
    description: 'Remove all audio from the output.',
  ),

  const FFmpegCustomCommand(
    title: 'Remove Video',
    command: '-vn',
    description: 'Remove all video from the output.',
  ),

  const FFmpegCustomCommand(
    title: 'Remove Subtitle',
    command: '-sn',
    description: 'Remove subtitle streams.',
  ),

  const FFmpegCustomCommand(
    title: 'Remove Data Streams',
    command: '-dn',
    description: 'Remove data streams.',
  ),

  // Resolution
  const FFmpegCustomCommand(
    title: '480p',
    command: '-vf scale=-2:480',
    description: 'Resize the video to 480 pixels high.',
  ),

  const FFmpegCustomCommand(
    title: '720p',
    command: '-vf scale=-2:720',
    description: 'Resize the video to 720 pixels high.',
  ),

  const FFmpegCustomCommand(
    title: '1080p',
    command: '-vf scale=-2:1080',
    description: 'Resize the video to 1080 pixels high.',
  ),

  const FFmpegCustomCommand(
    title: '1440p',
    command: '-vf scale=-2:1440',
    description: 'Resize the video to 1440 pixels high.',
  ),

  const FFmpegCustomCommand(
    title: '2160p / 4K',
    command: '-vf scale=-2:2160',
    description: 'Resize the video to 2160 pixels high.',
  ),

  const FFmpegCustomCommand(
    title: 'Half Resolution',
    command: '-vf scale=iw/2:ih/2',
    description: 'Reduce both width and height by half.',
  ),

  const FFmpegCustomCommand(
    title: 'Double Resolution',
    command: '-vf scale=iw*2:ih*2',
    description: 'Double both width and height.',
  ),

  // Speed
  const FFmpegCustomCommand(
    title: '0.5x Speed',
    command: '-vf setpts=2.0*PTS -af atempo=0.5',
    description: 'Play video and audio at half speed.',
  ),

  const FFmpegCustomCommand(
    title: '0.75x Speed',
    command: '-vf setpts=1.3333*PTS -af atempo=0.75',
    description: 'Play video and audio at 0.75x speed.',
  ),

  const FFmpegCustomCommand(
    title: '1.25x Speed',
    command: '-vf setpts=0.8*PTS -af atempo=1.25',
    description: 'Play video and audio at 1.25x speed.',
  ),

  const FFmpegCustomCommand(
    title: '1.5x Speed',
    command: '-vf setpts=0.6667*PTS -af atempo=1.5',
    description: 'Play video and audio at 1.5x speed.',
  ),

  const FFmpegCustomCommand(
    title: 'Double Speed',
    command: '-vf setpts=0.5*PTS -af atempo=2.0',
    description: 'Play video and audio at 2x speed.',
  ),

  // Audio
  const FFmpegCustomCommand(
    title: 'Mute',
    command: '-an',
    description: 'Remove audio and create a silent video.',
  ),

  const FFmpegCustomCommand(
    title: 'Volume 50%',
    command: '-af volume=0.5',
    description: 'Reduce the audio volume to 50%.',
  ),

  const FFmpegCustomCommand(
    title: 'Volume 75%',
    command: '-af volume=0.75',
    description: 'Reduce the audio volume to 75%.',
  ),

  const FFmpegCustomCommand(
    title: 'Volume +50%',
    command: '-af volume=1.5',
    description: 'Increase the audio volume to 150%.',
  ),

  const FFmpegCustomCommand(
    title: 'Volume 200%',
    command: '-af volume=2',
    description: 'Increase the audio volume to 200%.',
  ),

  // Rotation and flip
  const FFmpegCustomCommand(
    title: 'Rotate 90° Clockwise',
    command: '-vf transpose=1',
    description: 'Rotate the video 90 degrees clockwise.',
  ),

  const FFmpegCustomCommand(
    title: 'Rotate 90° Counterclockwise',
    command: '-vf transpose=2',
    description: 'Rotate the video 90 degrees counterclockwise.',
  ),

  const FFmpegCustomCommand(
    title: 'Rotate 180°',
    command: '-vf hflip,vflip',
    description: 'Rotate the video 180 degrees.',
  ),

  const FFmpegCustomCommand(
    title: 'Horizontal Flip',
    command: '-vf hflip',
    description: 'Flip the video horizontally.',
  ),

  const FFmpegCustomCommand(
    title: 'Vertical Flip',
    command: '-vf vflip',
    description: 'Flip the video vertically.',
  ),

  // Video quality
  const FFmpegCustomCommand(
    title: 'High Quality H.264',
    command: '-c:v libx264 -crf 18',
    description: 'Encode H.264 with high visual quality.',
  ),

  const FFmpegCustomCommand(
    title: 'Balanced H.264',
    command: '-c:v libx264 -crf 23',
    description: 'Encode H.264 with balanced quality and file size.',
  ),

  const FFmpegCustomCommand(
    title: 'Small File H.264',
    command: '-c:v libx264 -crf 28',
    description: 'Encode H.264 with smaller file size.',
  ),

  const FFmpegCustomCommand(
    title: 'Fast H.264 Encoding',
    command: '-c:v libx264 -preset fast',
    description: 'Encode H.264 faster.',
  ),

  const FFmpegCustomCommand(
    title: 'Very Fast H.264 Encoding',
    command: '-c:v libx264 -preset veryfast',
    description: 'Encode H.264 with faster encoding speed.',
  ),

  // Frame rate
  const FFmpegCustomCommand(
    title: '24 FPS',
    command: '-r 24',
    description: 'Convert output video to 24 frames per second.',
  ),

  const FFmpegCustomCommand(
    title: '30 FPS',
    command: '-r 30',
    description: 'Convert output video to 30 frames per second.',
  ),

  const FFmpegCustomCommand(
    title: '60 FPS',
    command: '-r 60',
    description: 'Convert output video to 60 frames per second.',
  ),

  // Video filters
  const FFmpegCustomCommand(
    title: 'Grayscale',
    command: '-vf hue=s=0',
    description: 'Convert the video to grayscale.',
  ),

  const FFmpegCustomCommand(
    title: 'Brightness +10%',
    command: '-vf eq=brightness=0.1',
    description: 'Increase video brightness.',
  ),

  const FFmpegCustomCommand(
    title: 'Brightness -10%',
    command: '-vf eq=brightness=-0.1',
    description: 'Decrease video brightness.',
  ),

  const FFmpegCustomCommand(
    title: 'Contrast +20%',
    command: '-vf eq=contrast=1.2',
    description: 'Increase video contrast.',
  ),

  const FFmpegCustomCommand(
    title: 'Contrast -20%',
    command: '-vf eq=contrast=0.8',
    description: 'Decrease video contrast.',
  ),

  const FFmpegCustomCommand(
    title: 'Saturation +50%',
    command: '-vf eq=saturation=1.5',
    description: 'Increase color saturation.',
  ),

  const FFmpegCustomCommand(
    title: 'Saturation -50%',
    command: '-vf eq=saturation=0.5',
    description: 'Reduce color saturation.',
  ),

  // Audio bitrate
  const FFmpegCustomCommand(
    title: 'Audio 64 kbps',
    command: '-b:a 64k',
    description: 'Set audio bitrate to 64 kbps.',
  ),

  const FFmpegCustomCommand(
    title: 'Audio 128 kbps',
    command: '-b:a 128k',
    description: 'Set audio bitrate to 128 kbps.',
  ),

  const FFmpegCustomCommand(
    title: 'Audio 192 kbps',
    command: '-b:a 192k',
    description: 'Set audio bitrate to 192 kbps.',
  ),

  const FFmpegCustomCommand(
    title: 'Audio 256 kbps',
    command: '-b:a 256k',
    description: 'Set audio bitrate to 256 kbps.',
  ),

  const FFmpegCustomCommand(
    title: 'Audio 320 kbps',
    command: '-b:a 320k',
    description: 'Set audio bitrate to 320 kbps.',
  ),

  // Metadata
  const FFmpegCustomCommand(
    title: 'Clear Metadata',
    command: '-map_metadata -1',
    description: 'Remove metadata from the output.',
  ),

  const FFmpegCustomCommand(
    title: 'Clear Chapters',
    command: '-map_chapters -1',
    description: 'Remove chapter information.',
  ),
];
