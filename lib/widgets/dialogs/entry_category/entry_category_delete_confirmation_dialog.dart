import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/providers/entry_category_provider.dart';
import 'package:popcorn/utils/toast_helper.dart';
import 'package:provider/provider.dart';
import 'package:popcorn/utils/global_const.dart';

class EntryCategoryDeleteConfirmationDialog extends StatefulWidget {
  final EntryCategory entryCategory;

  const EntryCategoryDeleteConfirmationDialog({
    super.key,
    required this.entryCategory,
  });

  @override
  State<EntryCategoryDeleteConfirmationDialog> createState() =>
      _EntryCategoryDeleteConfirmationDialogState();
}

class _EntryCategoryDeleteConfirmationDialogState
    extends State<EntryCategoryDeleteConfirmationDialog> {
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
          "This will permanently delete the category!",
          style: TextStyle(color: GlobalConst.whiteColor),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// Close button
            MaterialButton(
              child: const Text(
                "NO",
                style: TextStyle(color: GlobalConst.greenColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            /// Confirmation Button
            MaterialButton(
              child: const Text(
                "YES",
                style: TextStyle(color: GlobalConst.redColor),
              ),
              onPressed: () {
                Provider.of<EntryCategoryProvider>(
                  context,
                  listen: false,
                ).delete(widget.entryCategory);
                ToastHelper.showSuccessToast(
                  "Successfully deleted the category",
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
