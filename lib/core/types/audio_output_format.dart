enum AudioOutputFormat {
  mp3,
  aac,
  wav,
  m4a,
  flac,
  ogg,
  opus;

  String get label {
    return switch (this) {
      mp3 => 'Mp3',
      aac => 'AAC',
      wav => 'WAV',
      m4a => 'M4A',
      flac => 'FLAC',
      ogg => 'OGG',
      opus => 'OPUS',
    };
  }
}

class AudioFormatConfig {
  final String extension;
  final String codec;
  final bool supportsBitrate;

  const AudioFormatConfig({
    required this.extension,
    required this.codec,
    this.supportsBitrate = true,
  });
}

extension AudioOutputFormatX on AudioOutputFormat {
  String get extension {
    return switch (this) {
      AudioOutputFormat.mp3 => 'mp3',
      AudioOutputFormat.m4a => 'm4a',
      AudioOutputFormat.aac => 'aac',
      AudioOutputFormat.wav => 'wav',
      AudioOutputFormat.flac => 'flac',
      AudioOutputFormat.opus => 'opus',
      AudioOutputFormat.ogg => 'ogg',
    };
  }

  String get codec {
    return switch (this) {
      AudioOutputFormat.mp3 => 'libmp3lame',
      AudioOutputFormat.m4a => 'aac',
      AudioOutputFormat.aac => 'aac',
      AudioOutputFormat.wav => 'pcm_s16le',
      AudioOutputFormat.flac => 'flac',
      AudioOutputFormat.opus => 'libopus',
      AudioOutputFormat.ogg => 'libvorbis',
    };
  }

  AudioFormatConfig get config {
    return switch (this) {
      AudioOutputFormat.mp3 => const AudioFormatConfig(
        extension: 'mp3',
        codec: 'libmp3lame',
      ),

      AudioOutputFormat.m4a => const AudioFormatConfig(
        extension: 'm4a',
        codec: 'aac',
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
