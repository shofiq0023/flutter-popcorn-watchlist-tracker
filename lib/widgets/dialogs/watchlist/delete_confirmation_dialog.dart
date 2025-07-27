import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:provider/provider.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  final WatchlistEntry watchlistEntry;
  const DeleteConfirmationDialog({super.key, required this.watchlistEntry});

  @override
  State<DeleteConfirmationDialog> createState() => _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: SizedBox(
        width: 600,
        child: const Text("This will delete the entry permanently"),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// Close button
            MaterialButton(
              child: const Text("NO"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            /// Confirmation Button
            MaterialButton(
              child: const Text("YES", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Provider.of<WatchlistEntryProvider>(
                  context,
                  listen: false,
                ).delete(widget.watchlistEntry);
                Navigator.of(context).popUntil((route) => route is PageRoute);
              },
            ),
          ],
        ),
      ],
    );
  }
}
