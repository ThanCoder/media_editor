import 'package:flutter/material.dart';
import 'package:media_editor/platforms/desktop/platform_home_page.dart';
import 'package:media_editor/platforms/pages/more_page.dart';

class DesktopHomeScreen extends StatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) => setState(() {
              selectedIndex = value;
            }),
            destinations: [
              .new(icon: Icon(Icons.home), label: Text('Home')),
              .new(icon: Icon(Icons.grid_view_outlined), label: Text('More')),
            ],
          ),
          VerticalDivider(),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: [PlatformHomePage(), MorePage()],
            ),
          ),
        ],
      ),
    );
  }
}
