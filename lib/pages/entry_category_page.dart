import 'package:flutter/material.dart';
import 'package:popcorn/pages/components/entry_category_component.dart';
import 'package:popcorn/providers/entry_category_provider.dart';
import 'package:popcorn/widgets/dialogs/entry_category/entry_category_create_dialog.dart';
import 'package:popcorn/widgets/entry_category_selection_mode_bot_nav.dart';
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
          appBar: AppBar(
            title: provider.buildTitle(),
            actions: [
              IconButton(
                onPressed: provider.toggleSearch,
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          drawer: const MyNavigationDrawer(),
          drawerEnableOpenDragGesture: true,
          drawerEdgeDragWidth: 600,
          bottomNavigationBar:
              provider.isInSelectionMode
                  ? EntryCategorySelectionModeBottomNav()
                  : null,
          body: EntryCategoryComponent(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showEntryCreationDialog();
            },
            child: const Icon(Icons.add, size: 32.0),
          ),
        );
      },
    );
  }

  void showEntryCreationDialog() {
    showDialog(
      context: context,
      builder: (context) => const EntryCategoryCreateDialog(),
    );
  }
}
