import 'package:flutter/material.dart';
import 'package:popcorn/widgets/dialogs/generic_delete_confirmation_dialog.dart';
import 'package:provider/provider.dart';
import 'package:popcorn/utils/global_const.dart';

import '../providers/entry_category_provider.dart';

class EntryCategorySelectionModeBottomNav extends StatelessWidget {
  const EntryCategorySelectionModeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EntryCategoryProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1D193A),
        border: Border(top: BorderSide(color: GlobalConst.blackColor)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            offset: Offset(0, -3),
            blurRadius: 8,
            spreadRadius: 5,
          ),
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
                color: GlobalConst.redColor,
                tooltip: "Delete",
              ),

              // Cancel Button
              IconButton(
                onPressed: () {
                  provider.disableSelectionMode();
                },
                icon: const Icon(Icons.close_sharp),
                iconSize: 30.0,
                color: GlobalConst.whiteColor,
                tooltip: "Cancel",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
