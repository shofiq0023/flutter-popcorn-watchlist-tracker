import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/providers/entry_category_provider.dart';
import 'package:popcorn/utils/toast_helper.dart';
import 'package:provider/provider.dart';
import 'package:popcorn/utils/global_const.dart';

class EntryCategoryCreateDialog extends StatefulWidget {
  const EntryCategoryCreateDialog({super.key});

  @override
  State<EntryCategoryCreateDialog> createState() =>
      _EntryCategoryCreateDialogState();
}

class _EntryCategoryCreateDialogState extends State<EntryCategoryCreateDialog> {
  final TextEditingController _entryCategoryNameTextController =
      TextEditingController();

  bool _nameError = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Create a new category",
        style: TextStyle(color: GlobalConst.whiteColor),
      ),
      backgroundColor: GlobalConst.dialogBoxBg,
      content: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title of the entry
            TextField(
              controller: _entryCategoryNameTextController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(color: GlobalConst.whiteColor),
              decoration: InputDecoration(
                error:
                    _nameError
                        ? const Text(
                          "Please enter a name!",
                          style: TextStyle(color: GlobalConst.redColor),
                        )
                        : null,
                label: Text(
                  "Category name",
                  style: TextStyle(fontSize: 16.0, color: Color(0xFFCAC1FF)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: GlobalConst.whiteColor,
                  ), // Normal state
                ),
              ),
              onChanged: (value) {
                if (_entryCategoryNameTextController.text.isEmpty) {
                  setState(() {
                    _nameError = true;
                  });
                } else {
                  setState(() {
                    _nameError = false;
                  });
                }
              },
            ),
          ],
        ),
      ),

      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// Close button
            MaterialButton(
              child: const Text(
                "CLOSE",
                style: TextStyle(color: GlobalConst.whiteColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            /// Create button
            Consumer<EntryCategoryProvider>(
              builder: (context, provider, child) {
                return MaterialButton(
                  onPressed: () {
                    if (isSubmittable()) {
                      _createEntryCategory(provider, context);
                    } else {
                      ToastHelper.showWarningToast("Please enter a name!");
                    }
                  },
                  child: Text(
                    "CREATE",
                    style: TextStyle(
                      color: isSubmittable() ? GlobalConst.greenColor : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Add a new entry to the database
  void _createEntryCategory(
    EntryCategoryProvider provider,
    BuildContext context,
  ) {
    EntryCategory entry = EntryCategory();
    entry.categoryName = _entryCategoryNameTextController.text;

    provider.add(entry);
    ToastHelper.showSuccessToast("Successfully added a category");
    Navigator.pop(context);
  }

  /// Check the category name
  bool isSubmittable() {
    return _entryCategoryNameTextController.text.isNotEmpty;
  }
}
