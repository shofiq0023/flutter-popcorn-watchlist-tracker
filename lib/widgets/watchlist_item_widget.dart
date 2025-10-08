import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/utils/global_const.dart';
import 'package:popcorn/widgets/dialogs//watchlist/watchlist_entry_finished_confirmation_dialog.dart';
import 'package:popcorn/widgets/dialogs/watchlist/delete_confirmation_dialog.dart';
import 'package:popcorn/widgets/dialogs/watchlist/watchlist_entry_detail_dialog.dart';
import 'package:provider/provider.dart';

class WatchlistItemWidget extends StatefulWidget {
  final WatchlistEntry watchlistEntry;
  final bool isSelected;
  final bool isInSelectionMode;

  const WatchlistItemWidget({
    super.key,
    required this.watchlistEntry,
    required this.isSelected,
    required this.isInSelectionMode,
  });

  @override
  State<WatchlistItemWidget> createState() => _WatchlistItemWidgetState();
}

class _WatchlistItemWidgetState extends State<WatchlistItemWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WatchlistEntryProvider>(context);

    return GestureDetector(
      onLongPress: () {
        if (widget.isInSelectionMode) {
          provider.disableSelectionMode();
        } else {
          provider.enableSelectionMode();
          provider.addToSelectedEntry(widget.watchlistEntry);
        }
      },
      onTap: () {
        if (widget.isInSelectionMode) {
          if (widget.isSelected) {
            provider.removeFromSelectedEntry(widget.watchlistEntry);
          } else {
            provider.addToSelectedEntry(widget.watchlistEntry);
          }
        } else {
          showUpdateDialog();
        }
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: GlobalConst.dialogBoxBg,
          border: getBorderForSelectionMode(),
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
              Container(width: 4.0, color: getPriorityBasedColor()),

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
                                color: Color(0xFFF0F0F0),
                                fontSize: 21.0,
                                fontWeight: FontWeight.w500
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
                                color: Color(0x80F0F0F0),
                                fontSize: 12.0,
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
                            if (widget.isInSelectionMode) {
                              return;
                            }

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
                            color:
                                widget.isInSelectionMode
                                    ? Colors.grey
                                    : GlobalConst.redColor,
                            size: 28.0,
                          ),
                        )
                        : IconButton(
                          /// Finish button
                          onPressed: () {
                            if (widget.isInSelectionMode) {
                              return;
                            }
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
                            color:
                                widget.isInSelectionMode
                                    ? Colors.grey
                                    : GlobalConst.greenColor,
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
      return GlobalConst.highPriorityColor;
    } else if (entryPriority == 2) {
      return GlobalConst.mediumPriorityColor;
    }

    return Colors.transparent;
  }

  Border? getBorderForSelectionMode() {
    bool isSelected = widget.isSelected;

    if (isSelected) {
      return Border.all(
        color: Color(0xFF4A4AB5), // Border color
        width: 2.0, // Border width
      );
    }

    return null;
  }
}
