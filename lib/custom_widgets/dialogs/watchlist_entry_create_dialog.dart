import 'package:flutter/material.dart';
import 'package:popcorn/enums/watchlist_entry_type.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:provider/provider.dart';

class WatchlistEntryCreateDialog extends StatefulWidget {
  const WatchlistEntryCreateDialog({super.key});

  @override
  State<WatchlistEntryCreateDialog> createState() =>
      _WatchlistEntryCreateDialogState();
}

class _WatchlistEntryCreateDialogState
    extends State<WatchlistEntryCreateDialog> {
  final TextEditingController titleController = TextEditingController();
  String taskPriority = "High";

  List<DropdownMenuItem<String>> get dropdownList {
    return [
      const DropdownMenuItem(value: "High", child: Text("High")),
      const DropdownMenuItem(value: "Medium", child: Text("Medium")),
      const DropdownMenuItem(value: "Low", child: Text("Low")),
    ];
  }

  int getPriority(String p) {
    if (p == "High") {
      return 3;
    } else if (p == "Medium") {
      return 2;
    } else if (p == "Normal") {
      return 1;
    }

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create a new task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(label: Text("Task name")),
          ),
          const SizedBox(height: 10.0),
          DropdownButton<String>(
            value: taskPriority,
            isExpanded: true,
            hint: const Text(
              "Type of the show",
              style: TextStyle(color: Colors.white),
            ),
            onChanged: (String? str) {
              setState(() => taskPriority = str!);
            },
            items: dropdownList,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MaterialButton(
              child: const Text("Close", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Consumer<WatchlistEntryProvider>(
              builder: (context, provider, child) {
                return MaterialButton(
                  child: const Text(
                    "Create",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () => createWatchlistEntry(provider, context),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  void createWatchlistEntry(WatchlistEntryProvider provider, BuildContext context) {
    String title = titleController.text;

    WatchlistEntry entry = WatchlistEntry();
    entry.title = title;
    entry.type = "Test";
    entry.updatedAt = null;
    entry.finishedAt = null;
    entry.estimatedReleaseDate = null;

    provider.add(entry);
    Navigator.pop(context);
  }
}
