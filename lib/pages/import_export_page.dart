import 'package:flutter/material.dart';
import 'package:popcorn/providers/import_export_provider.dart';
import 'package:popcorn/widgets/navigation_drawer.dart';
import 'package:provider/provider.dart';

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
      body: Consumer<ImportExportProvider>(
        builder: (context, provider, child) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                provider.exportTableToJson();
              },
              child: const Text("Create Backup"),
            ),
          );
        },
      ),
    );
  }
}
