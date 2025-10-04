import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/utils/toast_helper.dart';
import 'package:provider/provider.dart';

import '../../../utils/global_const.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  final WatchlistEntry watchlistEntry;

  const DeleteConfirmationDialog({super.key, required this.watchlistEntry});

  @override
  State<DeleteConfirmationDialog> createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Are you sure?',
        style: TextStyle(color: GlobalConst.whiteColor),
      ),
      backgroundColor: GlobalConst.dialogBoxBg,
      content: SizedBox(
        width: 600,
        child: const Text(
          "This will delete the entry permanently",
          style: TextStyle(color: GlobalConst.whiteColor),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// Close button
            MaterialButton(
              child: const Text("NO", style: TextStyle(color: Color(0xFF059669)),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            /// Confirmation Button
            MaterialButton(
              child: const Text("YES", style: TextStyle(color: Color(0xFFDC2626))),
              onPressed: () {
                Provider.of<WatchlistEntryProvider>(
                  context,
                  listen: false,
                ).delete(widget.watchlistEntry);
                ToastHelper.showSuccessToast("Successfully deleted entry");
                Navigator.of(context).popUntil((route) => route is PageRoute);
              },
            ),
          ],
        ),
      ],
    );
  }
}
