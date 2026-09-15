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

  Color get color {
    return switch (this) {
      // Input / source
      input => Colors.blue,

      // Time / cutting
      trim => Colors.orange,

      // Audio
      volume => Colors.purple,

      // Information
      metadata => Colors.teal,

      // Image / artwork
      cover => Colors.pink,

      // Encoding / processing
      encode => Colors.indigo,

      // Output / destination
      output => Colors.green,

      // Stream / mapping
      stream => Colors.cyan,

      // Miscellaneous
      other => Colors.blueGrey,
    };
  }

  static BlockType fromVal(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => .other);
  }
}
