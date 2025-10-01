import 'package:flutter/material.dart';
import 'package:popcorn/widgets/dialogs/generic_delete_confirmation_dialog.dart';
import 'package:provider/provider.dart';

import '../providers/entry_category_provider.dart';

class EntryCategorySelectionModeBottomNav extends StatelessWidget {
  const EntryCategorySelectionModeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EntryCategoryProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white70,
        border: Border(top: BorderSide(color: Colors.black12)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), blurRadius: 10),
        ],
      ),

      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Delete Button
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => GenericDeleteConfirmationDialog(
                      text:
                      "This will permanently delete the selected categories!",
                      onAction: provider.deleteSelectedEntryCategories,
                    ),
                  );
                },
                icon: const Icon(Icons.delete_forever),
                iconSize: 30.0,
                color: Colors.redAccent,
                tooltip: "Delete",
              ),

              // Cancel Button
              IconButton(
                onPressed: () {
                  provider.disableSelectionMode();
                },
                icon: const Icon(Icons.close_sharp),
                iconSize: 30.0,
                color: Colors.black,
                tooltip: "Cancel",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
