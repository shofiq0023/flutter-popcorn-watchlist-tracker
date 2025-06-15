import 'package:flutter/material.dart';
import 'package:popcorn/widgets/navigation_drawer.dart';

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({super.key});

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Backup & Restore")),
      drawer: const MyNavigationDrawer(),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 600,
      body: const Center(child: Text("Backup & Restore Page")),
    );
  }
}
