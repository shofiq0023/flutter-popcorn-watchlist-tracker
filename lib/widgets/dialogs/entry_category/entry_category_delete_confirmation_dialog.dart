import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/providers/entry_category_provider.dart';
import 'package:provider/provider.dart';

class EntryCategoryDeleteConfirmationDialog extends StatefulWidget {
  final EntryCategory entryCategory;
  const EntryCategoryDeleteConfirmationDialog({super.key, required this.entryCategory});

  @override
  State<EntryCategoryDeleteConfirmationDialog> createState() => _EntryCategoryDeleteConfirmationDialogState();
}

class _EntryCategoryDeleteConfirmationDialogState extends State<EntryCategoryDeleteConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: SizedBox(
        width: 600,
        child: const Text("This will permanently delete the category!"),
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
                Provider.of<EntryCategoryProvider>(
                  context,
                  listen: false,
                ).delete(widget.entryCategory);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}