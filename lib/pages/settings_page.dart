import 'package:flutter/material.dart';
import 'package:popcorn/widgets/navigation_drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      drawer: const MyNavigationDrawer(),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 600,
      body: const Center(child: Text("Settings")),
    );
  }
}
