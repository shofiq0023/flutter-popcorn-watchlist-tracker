import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/utils/toast_helper.dart';
import 'package:provider/provider.dart';
import 'package:popcorn/utils/global_const.dart';

class WatchlistEntryFinishedDialog extends StatefulWidget {
  final WatchlistEntry watchlistEntry;

  const WatchlistEntryFinishedDialog({super.key, required this.watchlistEntry});

  @override
  State<WatchlistEntryFinishedDialog> createState() =>
      _WatchlistEntryFinishedDialogState();
}

class _WatchlistEntryFinishedDialogState
    extends State<WatchlistEntryFinishedDialog> {
  bool _isRecommendable = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Finished watching?',
        style: TextStyle(color: GlobalConst.whiteColor),
      ),
      backgroundColor: GlobalConst.dialogBoxBg,
      content: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: Text(
                "Recommendable",
                style: TextStyle(color: GlobalConst.whiteColor),
              ),
              value: _isRecommendable,
              onChanged: (bool? newValue) {
                setState(() {
                  _isRecommendable = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              checkColor: GlobalConst.whiteColor,
              side: BorderSide(
                color: GlobalConst.whiteColor, // Border color when unchecked
                width: 2,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Close button
            MaterialButton(
              child: const Text(
                "NO",
                style: TextStyle(color: GlobalConst.whiteColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            // Confirmation Button
            MaterialButton(
              child: const Text(
                "YES",
                style: TextStyle(color: GlobalConst.greenColor),
              ),
              onPressed: () {
                widget.watchlistEntry.isRecommendable = _isRecommendable;
                Provider.of<WatchlistEntryProvider>(
                  context,
                  listen: false,
                ).finished(widget.watchlistEntry);
                ToastHelper.showInfoToast("Successfully marked as finished");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
