import 'package:flutter/material.dart';

class CommandBlock {
  final String title;
  final String command;

  const CommandBlock({required this.title, required this.command});
}

class BlockEditorPage extends StatefulWidget {
  const BlockEditorPage({super.key});

  @override
  State<BlockEditorPage> createState() => _BlockEditorPageState();
}

class _BlockEditorPageState extends State<BlockEditorPage> {
  Offset position = const Offset(50, 100);

  final block = const CommandBlock(title: 'Volume', command: '-af volume=2');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Block Editor')),
      body: Stack(
        children: [
          Positioned(
            left: position.dx,
            top: position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  position += details.delta;
                });
              },
              child: CommandBlockWidget(block: block),
            ),
          ),
        ],
      ),
    );
  }
}

class CommandBlockWidget extends StatelessWidget {
  final CommandBlock block;

  const CommandBlockWidget({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            block.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(block.command, style: const TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }
}

class BlockPainter extends CustomPainter {
  const BlockPainter({required this.color, required this.borderColor});

  final Color color;
  final Color borderColor;

  static const notchWidth = 52.0;
  static const notchHeight = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    const radius = 10.0;

    const notchLeft = 28.0;
    const notchRight = notchLeft + notchWidth;

    final path = Path();

    // ─────────────────────────────
    // Top
    // ─────────────────────────────

    path.moveTo(radius, 0);

    path.lineTo(notchLeft, 0);

    // Top socket
    path.lineTo(notchLeft, notchHeight);
    path.lineTo(notchRight, notchHeight);
    path.lineTo(notchRight, 0);

    path.lineTo(size.width - radius, 0);

    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // ─────────────────────────────
    // Right
    // ─────────────────────────────

    path.lineTo(size.width, size.height - radius);

    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );

    // ─────────────────────────────
    // Bottom connector
    // ─────────────────────────────

    path.lineTo(notchRight, size.height);

    path.lineTo(notchRight, size.height + notchHeight);

    path.lineTo(notchLeft, size.height + notchHeight);

    path.lineTo(notchLeft, size.height);

    // ─────────────────────────────
    // Bottom left
    // ─────────────────────────────

    path.lineTo(radius, size.height);

    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    // ─────────────────────────────
    // Left
    // ─────────────────────────────

    path.lineTo(0, radius);

    path.quadraticBezierTo(0, 0, radius, 0);

    path.close();

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fill);

    final border = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(covariant BlockPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.borderColor != borderColor;
  }
}
