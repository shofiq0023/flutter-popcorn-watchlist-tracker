import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/widgets/watchlist_item_widget.dart';
import 'package:provider/provider.dart';
import 'package:popcorn/utils/global_const.dart';

class EntriesFinishedWindow extends StatefulWidget {
  const EntriesFinishedWindow({super.key});

  @override
  State<EntriesFinishedWindow> createState() => _EntriesFinishedWindowState();
}

class _EntriesFinishedWindowState extends State<EntriesFinishedWindow> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistEntryProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<List<WatchlistEntry>>(
          future: provider.watchList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: GlobalConst.whiteColor),));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No entries found', style: TextStyle(color: GlobalConst.whiteColor)));
            }

            final entries = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
                top: 5.0,
                bottom: 60.0,
              ),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return WatchlistItemWidget(
                  watchlistEntry: entries[index],
                  isSelected: provider.isSelectedEntry(entries[index]),
                  isInSelectionMode: provider.isSelectionMode,
                );
              },
            );
          },
        );
      },
    );
  }
}
