import 'package:flutter/material.dart';

enum BlockType {
  input,
  trim,
  volume,
  metadata,
  cover,
  encode,
  output,
  stream,
  other;

  IconData get iconData {
    return switch (this) {
      input => Icons.input_rounded,
      trim => Icons.content_cut_rounded,
      volume => Icons.volume_up_rounded,
      metadata => Icons.info_outline_rounded,
      cover => Icons.image_outlined,
      encode => Icons.transform_rounded,
      stream => Icons.alt_route_rounded,
      output => Icons.output_rounded,
      other => Icons.more_horiz_rounded,
    };
  }

  static BlockType fromVal(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => .other);
  }
}
