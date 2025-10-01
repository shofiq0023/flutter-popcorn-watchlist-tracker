import 'package:flutter/material.dart';
import 'package:popcorn/pages/components/custom_bottom_sheet.dart';
import 'package:popcorn/pages/components/entries_finished_window.dart';
import 'package:popcorn/pages/components/entries_unfinished_window.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/widgets/custom_bottom_navigation_bar.dart';
import 'package:popcorn/widgets/dialogs/watchlist/watchlist_entry_create_dialog.dart';
import 'package:popcorn/widgets/navigation_drawer.dart';
import 'package:popcorn/widgets/selection_mode_action_bot_nav.dart';
import 'package:provider/provider.dart';

class WatchlistHomePage extends StatefulWidget {
  const WatchlistHomePage({super.key});

  @override
  State<WatchlistHomePage> createState() => _WatchlistHomePageState();
}

class _WatchlistHomePageState extends State<WatchlistHomePage> {
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
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => CustomBottomSheet(),
                  );
                },
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.sort),

                    // Show the dot only if sorting is active
                    if (provider.currentSortType != "default") // default
                      Positioned(
                        right: -1,
                        top: -1,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.red, // dot color
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
          drawer: const MyNavigationDrawer(),
          drawerEnableOpenDragGesture: true,
          drawerEdgeDragWidth: 600,
          bottomNavigationBar:
              provider.isSelectionMode
                  ? SelectionModeActionBottomNav()
                  : CustomBottomNavigationBar(
                    selectedIndex: provider.pageIndex,
                    onIndexSelected: (index) {
                      provider.setPageIndex(index);
                    },
                  ),
          body:
              [
                const EntriesFinishedWindow(),
                const EntriesUnfinishedWindow(),
              ][provider.pageIndex],
          floatingActionButton:
              provider.isSelectionMode
                  ? null
                  : FloatingActionButton(
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
