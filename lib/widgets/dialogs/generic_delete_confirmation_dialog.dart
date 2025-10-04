import 'package:flutter/material.dart';
import 'package:popcorn/utils/global_const.dart';

class GenericDeleteConfirmationDialog extends StatelessWidget {
  final String text;
  final VoidCallback onAction;

  const GenericDeleteConfirmationDialog({
    super.key,
    required this.text,
    required this.onAction,
  });

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
        child: Text(text, style: TextStyle(color: GlobalConst.whiteColor)),
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
                onAction();
                Navigator.of(context).popUntil((route) => route is PageRoute);
              },
            ),
          ],
        ),
      ],
    );
  }
}
