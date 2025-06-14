import 'package:flutter/material.dart';
import 'package:popcorn/providers/entry_category_provider.dart';
import 'package:popcorn/widgets/navigation_drawer.dart';
import 'package:provider/provider.dart';

class EntryCategoryPage extends StatefulWidget {
  const EntryCategoryPage({super.key});

  @override
  State<EntryCategoryPage> createState() => _EntryCategoryPageState();
}

class _EntryCategoryPageState extends State<EntryCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EntryCategoryProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: Text("Categories")),
          drawer: const MyNavigationDrawer(),
          drawerEnableOpenDragGesture: true,
          drawerEdgeDragWidth: 600,
          body: const Center(child: Text("Entry Categories Page")),
        );
      },
    );
  }
}
