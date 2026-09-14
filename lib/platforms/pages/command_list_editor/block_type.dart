import 'package:flutter/material.dart';

enum BlockType {
  input,
  trim,
  volume,
  metadata,
  cover,
  encode,
  output,
  other;

  IconData get iconData {
    return switch (this) {
      input => Icons.input,
      trim => Icons.content_cut,
      volume => Icons.volume_up,
      metadata => Icons.info_outline,
      cover => Icons.image_outlined,
      encode => Icons.settings,
      output => Icons.output,
      other => Icons.devices_other,
    };
  }

  static BlockType fromVal(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => .other);
  }
}
