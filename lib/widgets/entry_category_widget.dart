import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/providers/entry_category_provider.dart';
import 'package:popcorn/widgets/dialogs/entry_category/entry_category_delete_confirmation_dialog.dart';
import 'package:popcorn/widgets/dialogs/entry_category/entry_category_detail_dialog.dart';
import 'package:provider/provider.dart';

class EntryCategoryItemWidget extends StatefulWidget {
  final EntryCategory entryCategory;
  final bool isSelected;
  final bool isInSelectionMode;

  const EntryCategoryItemWidget({
    super.key,
    required this.entryCategory,
    required this.isSelected,
    required this.isInSelectionMode,
  });

  @override
  State<EntryCategoryItemWidget> createState() =>
      _EntryCategoryItemWidgetState();
}

class _EntryCategoryItemWidgetState extends State<EntryCategoryItemWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EntryCategoryProvider>(context);

    return GestureDetector(
      onLongPress: () {
        if (widget.isInSelectionMode) {
          provider.disableSelectionMode();
        } else {
          provider.enableSelectionMode();
          provider.addToSelectedEntryCategory(widget.entryCategory);
        }
      },
      onTap: () {
        if (widget.isInSelectionMode) {
          if (widget.isSelected) {
            provider.removeFromSelectedEntryCategory(widget.entryCategory);
          } else {
            provider.addToSelectedEntryCategory(widget.entryCategory);
          }
        } else {
          showUpdateDialog();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.entryCategory.categoryName),
            IconButton(
              onPressed: () {
                if (widget.isInSelectionMode) {
                  return;
                }

                showDialog(
                  context: context,
                  builder:
                      (context) => EntryCategoryDeleteConfirmationDialog(
                        entryCategory: widget.entryCategory,
                      ),
                );
              },
              icon: Icon(
                Icons.delete_forever,
                color: widget.isInSelectionMode ? Colors.grey : Colors.red,
              ),
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

  Border? getBorderForSelectionMode() {
    bool isSelected = widget.isSelected;

    if (isSelected) {
      return Border.all(
        color: Colors.black38, // Border color
        width: 2.0, // Border width
      );
    }

    return null;
  }
}
