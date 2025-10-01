import 'package:flutter/material.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/widgets/dialogs/generic_delete_confirmation_dialog.dart';
import 'package:provider/provider.dart';

class SelectionModeActionBottomNav extends StatelessWidget {
  const SelectionModeActionBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WatchlistEntryProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white70,
        border: Border(top: BorderSide(color: Colors.black12)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), blurRadius: 10),
        ],
      ),

      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Delete Button
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => GenericDeleteConfirmationDialog(
                          text:
                              "This will permanently delete the selected entries!",
                          onAction: provider.deleteSelectedEntries,
                        ),
                  );
                },
                icon: const Icon(Icons.delete_forever),
                iconSize: 30.0,
                color: Colors.redAccent,
                tooltip: "Delete",
              ),

              // Finish Button (For unfinished entries)
              if (provider.pageIndex == 0)
                IconButton(
                  onPressed: () {
                    provider.finishSelectedEntries();
                  },
                  icon: const Icon(Icons.done_all),
                  iconSize: 30.0,
                  color: Colors.green,
                  tooltip: "Finished",
                ),

              // Remove Finished button (for finished entries)
              if (provider.pageIndex == 1)
                IconButton(
                  onPressed: () {
                    provider.removeFinishStatusFromSelectedEntries();
                  },
                  icon: const Icon(Icons.remove_done),
                  iconSize: 30.0,
                  color: Colors.green,
                  tooltip: "Remove from finished list",
                ),

              // Finish & Recommend Button (For unfinished entries)
              if (provider.pageIndex == 0)
                IconButton(
                  onPressed: () {
                    provider.finishSelectedEntries(recommendable: true);
                  },
                  icon: const Icon(Icons.bookmark_added),
                  iconSize: 30.0,
                  color: Colors.blueAccent,
                  tooltip: "Finished & Recommendable",
                ),

              // Remove Finished & Recommend button (for finished entries)
              if (provider.pageIndex == 1)
                IconButton(
                  onPressed: () {
                    provider.removeFinishAndRecommendStatusFromSelectedEntries(recommendable: false);
                  },
                  icon: const Icon(Icons.bookmark_remove),
                  iconSize: 30.0,
                  color: Colors.orangeAccent,
                  tooltip: "Remove Finished & Recommendable",
                ),

              // Cancel Button
              IconButton(
                onPressed: () {
                  provider.disableSelectionMode();
                },
                icon: const Icon(Icons.close_sharp),
                iconSize: 30.0,
                color: Colors.black,
                tooltip: "Cancel",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
