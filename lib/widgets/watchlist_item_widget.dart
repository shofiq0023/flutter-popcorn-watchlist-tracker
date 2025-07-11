import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/widgets/dialogs//watchlist/watchlist_entry_finished_confirmation_dialog.dart';
import 'package:popcorn/widgets/dialogs/watchlist/delete_confirmation_dialog.dart';
import 'package:popcorn/widgets/dialogs/watchlist/watchlist_entry_detail_dialog.dart';

class WatchlistItemWidget extends StatefulWidget {
  final WatchlistEntry watchlistEntry;

  const WatchlistItemWidget({super.key, required this.watchlistEntry});

  @override
  State<WatchlistItemWidget> createState() => _WatchlistItemWidgetState();
}

class _WatchlistItemWidgetState extends State<WatchlistItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showUpdateDialog();
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: getBorderStyleBasedOnUpcomingStatus(),
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),

        /// Main card content
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Priority tag
              Container(
                width: 4.0,
                color: getPriorityBasedColor(),
              ),

              const SizedBox(width: 12.0),

              /// Title and finish/delete button
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.watchlistEntry.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontVariations: const <FontVariation>[
                                  FontVariation('wght', 700.0),
                                ],
                              ),
                            ),
                            Text(
                              widget.watchlistEntry.category.target == null
                                  ? ""
                                  : widget
                                      .watchlistEntry
                                      .category
                                      .target!
                                      .categoryName,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 10.0,
                                fontVariations: const <FontVariation>[
                                  FontVariation('wght', 100.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Finish/Delete button
                    widget.watchlistEntry.isFinished
                        ? IconButton(
                          /// Delete Button
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => DeleteConfirmationDialog(
                                    watchlistEntry: widget.watchlistEntry,
                                  ),
                            );
                          },
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: 28.0,
                          ),
                        )
                        : IconButton(
                          /// Finish button
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => WatchlistEntryFinishedDialog(
                                    watchlistEntry: widget.watchlistEntry,
                                  ),
                            );
                          },
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 28.0,
                          ),
                        ),
                  ],
                ),
              ),

              const SizedBox(width: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  void showUpdateDialog() {
    showDialog(
      context: context,
      builder:
          (context) =>
              WatchlistEntryDetailDialog(watchlistEntry: widget.watchlistEntry),
    );
  }

  Color? getPriorityBasedColor() {
    int entryPriority = widget.watchlistEntry.priority;

    if (entryPriority == 1) {
      return Colors.red[700];
    } else if (entryPriority == 2) {
      return Colors.red[400];
    }

    return Colors.transparent;
  }

  Border? getBorderStyleBasedOnUpcomingStatus() {
    // WatchlistEntry entry = widget.watchlistEntry;
    //
    // if (entry.isUpcoming) {
    //   return Border.all(
    //     color: Colors.black38, // Border color
    //     width: 2.0, // Border width
    //   );
    // }

    return null;
  }
}
