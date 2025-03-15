import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:popcorn/widgets/dialogs/watchlist_entry_detail_dialog.dart';
import 'package:popcorn/widgets/dialogs/watchlist_entry_finished_confirmation_dialog.dart';

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
                // color: GlobalData.getPriorityColorForCard(
                //   widget.watchListModel.priority,
                // ),
                color: Colors.red,
              ),

              /// Padding between priority tag and titles
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
                              widget.watchlistEntry.type,
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
                        ? IconButton( /// Delete Button
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
                        : IconButton( /// Finish button
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

              /// Ending padding
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
}

