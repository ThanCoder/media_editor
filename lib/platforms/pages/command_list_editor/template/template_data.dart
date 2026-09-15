import 'package:media_editor/platforms/pages/command_list_editor/types/command_block.dart';
import 'package:media_editor/platforms/pages/command_list_editor/types/command_list_editor_template.dart';

final builtInTemplates = <CommandListEditorTemplate>[
  CommandListEditorTemplate(
    title: 'Video to MP3',
    desc: 'Extract audio from video and convert it to MP3.',
    date: DateTime(2026, 1, 1),
    blocks: [
      CommandBlock(
        id: 'input',
        type: .input,
        title: 'Input',
        command: '-i {input}',
        desc: 'Select the input video file.',
      ),
      CommandBlock(
        id: 'audio',
        type: .stream,
        title: 'Audio Only',
        command: '-vn',
        desc: 'Remove the video stream and keep audio only.',
      ),
      CommandBlock(
        id: 'mp3',
        type: .encode,
        title: 'MP3 Encode',
        command: '-c:a libmp3lame -b:a 192k',
        desc: 'Encode audio as MP3 at 192 kbps.',
      ),
      CommandBlock(
        id: 'output',
        type: .output,
        title: 'Output',
        command: '{output}.mp3',
        desc: 'Save the converted audio file.',
      ),
    ],
  ),

  CommandListEditorTemplate(
    title: 'Extract Audio',
    desc: 'Extract the original audio stream without re-encoding.',
    date: DateTime(2026, 1, 1),
    blocks: [
      CommandBlock(
        id: 'input',
        type: .input,
        title: 'Input',
        command: '-i {input}',
        desc: 'Select the input video file.',
      ),
      CommandBlock(
        id: 'audio',
        type: .stream,
        title: 'Audio Only',
        command: '-vn',
        desc: 'Keep only the audio stream.',
      ),
      CommandBlock(
        id: 'copy',
        type: .encode,
        title: 'Stream Copy',
        command: '-c:a copy',
        desc: 'Copy the original audio without re-encoding.',
      ),
      CommandBlock(
        id: 'output',
        type: .output,
        title: 'Output',
        command: '{output}',
        desc: 'Save the extracted audio.',
      ),
    ],
  ),

  CommandListEditorTemplate(
    title: 'Compress Video',
    desc: 'Reduce video size using H.264 encoding.',
    date: DateTime(2026, 1, 1),
    blocks: [
      CommandBlock(
        id: 'input',
        type: .input,
        title: 'Input',
        command: '-i {input}',
        desc: 'Select the input video.',
      ),
      CommandBlock(
        id: 'video',
        type: .encode,
        title: 'H.264',
        command: '-c:v libx264 -crf 23',
        desc: 'Encode the video using H.264.',
      ),
      CommandBlock(
        id: 'audio',
        type: .encode,
        title: 'AAC Audio',
        command: '-c:a aac -b:a 128k',
        desc: 'Encode audio using AAC at 128 kbps.',
      ),
      CommandBlock(
        id: 'output',
        type: .output,
        title: 'Output',
        command: '{output}.mp4',
        desc: 'Save the compressed video.',
      ),
    ],
  ),

  CommandListEditorTemplate(
    title: 'Trim Video',
    desc: 'Cut a section from a video without re-encoding.',
    date: DateTime(2026, 1, 1),
    blocks: [
      CommandBlock(
        id: 'input',
        type: .input,
        title: 'Input',
        command: '-i {input}',
        desc: 'Select the input video.',
      ),
      CommandBlock(
        id: 'trim',
        type: .trim,
        title: 'Trim',
        command: '-ss {start} -to {end}',
        desc: 'Select the start and end time.',
      ),
      CommandBlock(
        id: 'copy',
        type: .stream,
        title: 'Stream Copy',
        command: '-c copy',
        desc: 'Keep the original video and audio streams.',
      ),
      CommandBlock(
        id: 'output',
        type: .output,
        title: 'Output',
        command: '{output}.mp4',
        desc: 'Save the trimmed video.',
      ),
    ],
  ),

  CommandListEditorTemplate(
    title: 'Extract MP3 from Video',
    desc: 'Extract audio and encode it as a high-quality MP3.',
    date: DateTime(2026, 1, 1),
    blocks: [
      CommandBlock(
        id: 'input',
        type: .input,
        title: 'Input',
        command: '-i {input}',
        desc: 'Select the source video.',
      ),
      CommandBlock(
        id: 'stream',
        type: .stream,
        title: 'Audio Only',
        command: '-vn',
        desc: 'Disable video output.',
      ),
      CommandBlock(
        id: 'encode',
        type: .encode,
        title: 'MP3 320k',
        command: '-c:a libmp3lame -b:a 320k',
        desc: 'Encode audio as 320 kbps MP3.',
      ),
      CommandBlock(
        id: 'output',
        type: .output,
        title: 'Output',
        command: '{output}.mp3',
        desc: 'Save the MP3 file.',
      ),
    ],
  ),

  CommandListEditorTemplate(
    title: 'Resize Video to 720p',
    desc: 'Scale a video to 720p while preserving the aspect ratio.',
    date: DateTime(2026, 1, 1),
    blocks: [
      CommandBlock(
        id: 'input',
        type: .input,
        title: 'Input',
        command: '-i {input}',
        desc: 'Select the input video.',
      ),
      CommandBlock(
        id: 'scale',
        type: .encode,
        title: '720p',
        command: '-vf scale=-2:720',
        desc: 'Resize the video height to 720 pixels.',
      ),
      CommandBlock(
        id: 'video',
        type: .encode,
        title: 'H.264',
        command: '-c:v libx264 -crf 23',
        desc: 'Encode the resized video.',
      ),
      CommandBlock(
        id: 'audio',
        type: .encode,
        title: 'AAC',
        command: '-c:a aac -b:a 128k',
        desc: 'Encode audio as AAC.',
      ),
      CommandBlock(
        id: 'output',
        type: .output,
        title: 'Output',
        command: '{output}.mp4',
        desc: 'Save the resized video.',
      ),
    ],
  ),

  CommandListEditorTemplate(
    title: 'Change Volume',
    desc: 'Increase or decrease the audio volume.',
    date: DateTime(2026, 1, 1),
    blocks: [
      CommandBlock(
        id: 'input',
        type: .input,
        title: 'Input',
        command: '-i {input}',
        desc: 'Select the input media.',
      ),
      CommandBlock(
        id: 'volume',
        type: .volume,
        title: 'Volume',
        command: '-af volume={volume}',
        desc: 'Adjust the audio volume.',
      ),
      CommandBlock(
        id: 'encode',
        type: .encode,
        title: 'AAC',
        command: '-c:a aac -b:a 192k',
        desc: 'Encode the modified audio.',
      ),
      CommandBlock(
        id: 'output',
        type: .output,
        title: 'Output',
        command: '{output}.m4a',
        desc: 'Save the processed audio.',
      ),
    ],
  ),

  CommandListEditorTemplate(
    title: 'Convert to FLAC',
    desc: 'Convert audio to lossless FLAC format.',
    date: DateTime(2026, 1, 1),
    blocks: [
      CommandBlock(
        id: 'input',
        type: .input,
        title: 'Input',
        command: '-i {input}',
        desc: 'Select the input audio.',
      ),
      CommandBlock(
        id: 'encode',
        type: .encode,
        title: 'FLAC',
        command: '-c:a flac',
        desc: 'Encode audio using lossless FLAC.',
      ),
      CommandBlock(
        id: 'output',
        type: .output,
        title: 'Output',
        command: '{output}.flac',
        desc: 'Save the FLAC file.',
      ),
    ],
  ),
];
