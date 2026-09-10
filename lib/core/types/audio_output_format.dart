enum AudioOutputFormat { mp3, aac, wav, m4a, flac, ogg, opus }

extension AudioOutputFormatX on AudioOutputFormat {
  String get label {
    return switch (this) {
      .mp3 => 'Mp3',
      .aac => 'AAC',
      .wav => 'WAV',
      .m4a => 'M4A',
      .flac => 'FLAC',
      .ogg => 'OGG',
      .opus => 'OPUS',
    };
  }

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
}
