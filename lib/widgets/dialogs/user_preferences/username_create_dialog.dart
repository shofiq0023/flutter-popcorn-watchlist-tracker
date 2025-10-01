import 'package:flutter/material.dart';
import 'package:popcorn/providers/user_preferences_provider.dart';
import 'package:popcorn/utils/toast_helper.dart';
import 'package:provider/provider.dart';

class UsernameCreateDialog extends StatefulWidget {
  final String username;
  const UsernameCreateDialog({super.key, required this.username});

  @override
  State<UsernameCreateDialog> createState() => _UsernameCreateDialogState();
}

class _UsernameCreateDialogState extends State<UsernameCreateDialog> {
  final TextEditingController _usernameTextController = TextEditingController();

  bool _nameError = false;

  @override
  void initState() {
    _usernameTextController.text = widget.username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("What should I call you?"),
      content: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title of the entry
            TextField(
              controller: _usernameTextController,
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
                  "Username",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              onChanged: (value) {
                if (_usernameTextController.text.isEmpty) {
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
              child: const Text("CLOSE"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            /// Create button
            Consumer<UserPreferencesProvider>(
              builder: (context, provider, child) {
                return MaterialButton(
                  onPressed: () {
                    if (isSubmittable()) {
                      _usernameUpdate(provider, context);
                    } else {
                      ToastHelper.showWarningToast("Please enter your name!");
                    }
                  },
                  child: Text(
                    "SAVE",
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

  /// Add a new entry to the database
  void _usernameUpdate(UserPreferencesProvider provider, BuildContext context,) {
    String username = _usernameTextController.text;
    provider.updateUsername(username);
    ToastHelper.showSuccessToast("Successfully updated your name!");
    Navigator.pop(context);
  }

  /// Check the category name
  bool isSubmittable() {
    return _usernameTextController.text.isNotEmpty;
  }
}
