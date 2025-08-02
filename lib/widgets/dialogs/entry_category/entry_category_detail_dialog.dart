import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/providers/entry_category_provider.dart';
import 'package:popcorn/utils/toast_helper.dart';
import 'package:popcorn/utils/utils.dart';
import 'package:provider/provider.dart';

class EntryCategoryDetailDialog extends StatefulWidget {
  final EntryCategory entryCategory;
  const EntryCategoryDetailDialog({super.key, required this.entryCategory});

  @override
  State<EntryCategoryDetailDialog> createState() => _EntryCategoryDetailDialogState();
}

class _EntryCategoryDetailDialogState extends State<EntryCategoryDetailDialog> {
  final TextEditingController _entryCategoryNameTextController = TextEditingController();
  final TextEditingController _entryCategoryCreationDateController = TextEditingController();
  final TextEditingController _entryCategoryUpdateDateController = TextEditingController();

  bool _nameError = false;

  @override
  void initState() {
    EntryCategory entry = widget.entryCategory;
    _entryCategoryNameTextController.text = entry.categoryName;

    _entryCategoryCreationDateController.text = Utils.dateTimeToStrDateWithTime(entry.createdAt);
    _entryCategoryUpdateDateController.text = Utils.dateTimeToStrDateWithTime(entry.updatedAt);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Update category"),
      content: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title of the entry
            TextField(
              controller: _entryCategoryNameTextController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                error:
                _nameError
                    ? const Text(
                  "Please enter a name!",
                  style: TextStyle(color: Colors.redAccent),
                )
                    : null,
                label: Text(
                  "Category name",
                  style: TextStyle(fontSize: 16.0),
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

            const SizedBox(height: 25.0),

            /// Entry creation date
            TextField(
              controller: _entryCategoryCreationDateController,
              readOnly: true, // Prevent manual typing
              decoration: InputDecoration(
                  labelText: "Created at",
                  border: InputBorder.none
              ),
            ),

            /// Entry update date
            Visibility(
              visible: _entryCategoryUpdateDateController.text.isNotEmpty,
              child: TextField(
                controller: _entryCategoryUpdateDateController,
                readOnly: true, // Prevent manual typing
                decoration: InputDecoration(
                    labelText: "Last updated at",
                    border: InputBorder.none
                ),
              ),
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
              child: const Text("CLOSE"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            /// Create button
            Consumer<EntryCategoryProvider>(
              builder: (context, provider, child) {
                return MaterialButton(
                  onPressed:
                  isSubmittable()
                      ? () => _updateEntryCategory(provider, context)
                      : null,
                  child: Text(
                    "UPDATE",
                    style: TextStyle(
                      color: isSubmittable() ? Colors.green : Colors.grey,
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

  /// Update entry category
  void _updateEntryCategory(EntryCategoryProvider provider, BuildContext context) {
    EntryCategory category = widget.entryCategory;
    category.categoryName = _entryCategoryNameTextController.text;

    provider.update(category);
    ToastHelper.showSuccessToast("Successfully updated the category");
    Navigator.pop(context);
  }

  /// Check the category name
  bool isSubmittable() {
    return _entryCategoryNameTextController.text.isNotEmpty;
  }
}
