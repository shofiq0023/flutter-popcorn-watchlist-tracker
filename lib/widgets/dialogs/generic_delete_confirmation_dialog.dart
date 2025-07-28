import 'package:flutter/material.dart';

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
      title: const Text('Are you sure?'),
      content: SizedBox(
        width: 600,
        child: Text(text),
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
