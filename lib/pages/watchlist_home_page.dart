import 'package:flutter/material.dart';
import 'package:popcorn/pages/components/entries_finished_window.dart';
import 'package:popcorn/pages/components/entries_unfinished_window.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/widgets/custom_bottom_navigation_bar.dart';
import 'package:popcorn/widgets/dialogs/watchlist_entry_create_dialog.dart';
import 'package:popcorn/widgets/navigation_drawer.dart';
import 'package:provider/provider.dart';

class WatchlistHomePage extends StatefulWidget {
  const WatchlistHomePage({super.key});

  @override
  State<WatchlistHomePage> createState() => _WatchlistHomePageState();
}

class _WatchlistHomePageState extends State<WatchlistHomePage> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistEntryProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: provider.buildTitle(),
            actions: [
              IconButton(
                onPressed: provider.toggleSearch,
                icon: const Icon(Icons.search),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
            ],
          ),
          drawer: const MyNavigationDrawer(),
          drawerEnableOpenDragGesture: true,
          drawerEdgeDragWidth: 600,
          bottomNavigationBar: CustomBottomNavigationBar(
            onIndexSelected: (index) {
              setState(() {
                pageIndex = index;
              });
            },
          ),
          body:
              [
                const EntriesFinishedWindow(),
                const EntriesUnfinishedWindow(),
              ][pageIndex],
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
      builder: (context) => const WatchlistEntryCreateDialog(),
    );
  }
}
