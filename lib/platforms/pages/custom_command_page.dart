import 'package:flutter/material.dart';
import 'package:media_editor/platforms/pages/buildin_command_page.dart';
import 'package:media_editor/platforms/pages/saved_command_page.dart';

class CustomCommandPage extends StatefulWidget {
  const new({super.key});

  @override
  State<CustomCommandPage> createState() => _CustomCommandPageState();
}

class _CustomCommandPageState extends State<CustomCommandPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [BuildinCommandPage(), SavedCommandPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() {
            index = value;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'BuildIn'),
          NavigationDestination(
            icon: Icon(Icons.save_outlined),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
