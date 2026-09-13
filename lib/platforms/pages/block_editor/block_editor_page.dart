import 'package:flutter/material.dart';

enum BlockType { input, trim, volume, metadata, cover, encode, output }

class BlockData {
  const BlockData({
    required this.type,
    required this.title,
    required this.description,
  });

  final BlockType type;
  final String title;
  final String description;
}

const mockBlocks = [
  BlockData(
    type: BlockType.input,
    title: 'Input',
    description: 'Select media file',
  ),
  BlockData(
    type: BlockType.trim,
    title: 'Trim',
    description: 'Start: 10s\nEnd: End',
  ),
  BlockData(type: BlockType.volume, title: 'Volume', description: 'Volume: 2x'),
  BlockData(
    type: BlockType.metadata,
    title: 'Metadata',
    description: 'Title / Artist / Album',
  ),
  BlockData(
    type: BlockType.cover,
    title: 'Cover Art',
    description: 'Use embedded cover',
  ),
  BlockData(type: BlockType.encode, title: 'Encode', description: 'AAC'),
  BlockData(type: BlockType.output, title: 'Output', description: 'M4A'),
];

class BlockEditorPage extends StatelessWidget {
  const BlockEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FFmpeg Blocks'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Run',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.code),
            tooltip: 'View Command',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;

          if (isWide) {
            return Row(
              children: [
                SizedBox(width: 230, child: BlockPalette()),
                VerticalDivider(width: 1, color: colorScheme.outlineVariant),
                const Expanded(child: BlockWorkspace()),
              ],
            );
          }

          return Column(
            children: [
              SizedBox(height: 125, child: BlockPalette(horizontal: true)),
              Divider(height: 1, color: colorScheme.outlineVariant),
              const Expanded(child: BlockWorkspace()),
            ],
          );
        },
      ),
    );
  }
}

class BlockPalette extends StatelessWidget {
  const BlockPalette({super.key, this.horizontal = false});

  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    if (horizontal) {
      return ListView.separated(
        padding: const EdgeInsets.all(12),
        scrollDirection: Axis.horizontal,
        itemCount: mockBlocks.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 150,
            child: PaletteBlock(block: mockBlocks[index]),
          );
        },
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: mockBlocks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return PaletteBlock(block: mockBlocks[index]);
      },
    );
  }
}

class PaletteBlock extends StatelessWidget {
  const PaletteBlock({super.key, required this.block});

  final BlockData block;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LongPressDraggable<BlockData>(
      data: block,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 210, child: EditorBlock(block: block)),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(iconForBlock(block.type), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                block.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlockWorkspace extends StatefulWidget {
  const BlockWorkspace({super.key});

  @override
  State<BlockWorkspace> createState() => _BlockWorkspaceState();
}

class _BlockWorkspaceState extends State<BlockWorkspace> {
  final blocks = <BlockData>[
    mockBlocks[0],
    mockBlocks[1],
    mockBlocks[2],
    mockBlocks[3],
    mockBlocks[4],
    mockBlocks[5],
    mockBlocks[6],
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DragTarget<BlockData>(
      onAcceptWithDetails: (details) {
        setState(() {
          blocks.add(details.data);
        });
      },
      builder: (context, candidateData, rejectedData) {
        return InteractiveViewer(
          minScale: .5,
          maxScale: 2,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minWidth: 500, minHeight: 900),
            color: colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < blocks.length; i++) ...[
                  EditorBlock(block: blocks[i]),
                  if (i != blocks.length - 1) const BlockConnector(),
                ],

                const SizedBox(height: 30),

                if (candidateData.isNotEmpty) const AddBlockHint(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EditorBlock extends StatelessWidget {
  const EditorBlock({super.key, required this.block});

  final BlockData block;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 310,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            color: colorScheme.primaryContainer,
            child: Row(
              children: [
                Icon(
                  iconForBlock(block.type),
                  size: 20,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    block.title,
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  size: 20,
                  color: colorScheme.onPrimaryContainer,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              block.description,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class BlockConnector extends StatelessWidget {
  const BlockConnector({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 34,
      child: Row(
        children: [
          const SizedBox(width: 28),
          Container(
            width: 4,
            height: double.infinity,
            color: colorScheme.outline,
          ),
        ],
      ),
    );
  }
}

class AddBlockHint extends StatelessWidget {
  const AddBlockHint({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 310,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.primary, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.add_circle_outline, color: colorScheme.primary),
          const SizedBox(width: 10),
          Text('Drop block here', style: TextStyle(color: colorScheme.primary)),
        ],
      ),
    );
  }
}

IconData iconForBlock(BlockType type) {
  return switch (type) {
    BlockType.input => Icons.input,
    BlockType.trim => Icons.content_cut,
    BlockType.volume => Icons.volume_up,
    BlockType.metadata => Icons.text_fields,
    BlockType.cover => Icons.image,
    BlockType.encode => Icons.code,
    BlockType.output => Icons.output,
  };
}
