import 'package:media_editor/core/types/audio_output_format.dart';

class AudioFormatConfig {
  final String extension;
  final String codec;
  final bool supportsBitrate;
  final bool supportCoverArt;

  const AudioFormatConfig({
    required this.extension,
    required this.codec,
    this.supportsBitrate = true,
    this.supportCoverArt = false,
  });
}

extension AudioFormatConfigX on AudioOutputFormat {
  AudioFormatConfig get config {
    return switch (this) {
      AudioOutputFormat.mp3 => const AudioFormatConfig(
        extension: 'mp3',
        codec: 'libmp3lame',
        supportCoverArt: true,
      ),

      AudioOutputFormat.m4a => const AudioFormatConfig(
        extension: 'm4a',
        codec: 'aac',
        supportCoverArt: true,
      ),

      AudioOutputFormat.aac => const AudioFormatConfig(
        extension: 'aac',
        codec: 'aac',
      ),

      AudioOutputFormat.wav => const AudioFormatConfig(
        extension: 'wav',
        codec: 'pcm_s16le',
        supportsBitrate: false,
      ),

      AudioOutputFormat.flac => const AudioFormatConfig(
        extension: 'flac',
        codec: 'flac',
        supportsBitrate: false,
        supportCoverArt: true,
      ),

      AudioOutputFormat.opus => const AudioFormatConfig(
        extension: 'opus',
        codec: 'libopus',
      ),

      AudioOutputFormat.ogg => const AudioFormatConfig(
        extension: 'ogg',
        codec: 'libvorbis',
      ),
    };
  }
}
