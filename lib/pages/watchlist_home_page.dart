import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/widgets/dialogs/watchlist_entry_create_dialog.dart';
import 'package:popcorn/widgets/navigation_drawer.dart';
import 'package:popcorn/widgets/watchlist_item_widget.dart';
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
              IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
            ],
          ),
          drawer: const MyNavigationDrawer(),
          body: FutureBuilder<List<WatchlistEntry>>(
            future: provider.watchList,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No entries found'));
              }

              final entries = snapshot.data!;

              return ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return WatchlistItemWidget(watchlistEntry: entries[index]);
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showTaskAddingDialogue();
            },
            child: const Icon(Icons.add, size: 32.0),
          ),
        );
      },
    );
  }

  void showTaskAddingDialogue() {
    showDialog(
      context: context,
      builder: (context) => const WatchlistEntryCreateDialog(),
    );
  }
}
