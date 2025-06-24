import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/widgets/dialogs/entry_category/entry_category_delete_confirmation_dialog.dart';
import 'package:popcorn/widgets/dialogs/entry_category/entry_category_detail_dialog.dart';

class EntryCategoryItemWidget extends StatefulWidget {
  final EntryCategory entryCategory;

  const EntryCategoryItemWidget({super.key, required this.entryCategory});

  @override
  State<EntryCategoryItemWidget> createState() =>
      _EntryCategoryItemWidgetState();
}

class _EntryCategoryItemWidgetState extends State<EntryCategoryItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showUpdateDialog();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.entryCategory.categoryName),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => EntryCategoryDeleteConfirmationDialog(
                        entryCategory: widget.entryCategory,
                      ),
                );
              },
              icon: Icon(Icons.delete_forever, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void showUpdateDialog() {
    showDialog(
      context: context,
      builder:
          (context) =>
              EntryCategoryDetailDialog(entryCategory: widget.entryCategory),
    );
  }
}
