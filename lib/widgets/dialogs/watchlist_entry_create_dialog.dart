import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/utils/utils.dart';
import 'package:provider/provider.dart';

class WatchlistEntryCreateDialog extends StatefulWidget {
  const WatchlistEntryCreateDialog({super.key});

  @override
  State<WatchlistEntryCreateDialog> createState() =>
      _WatchlistEntryCreateDialogState();
}

class _WatchlistEntryCreateDialogState extends State<WatchlistEntryCreateDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _estimatedReleaseDateController = TextEditingController();

  bool _titleError = false;
  bool _isUpcomingEntry = false;
  String? _entryType;
  int _selectedPriority = 3;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create a new entry"),
      content: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title of the entry
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                error:
                    _titleError
                        ? const Text(
                          "Please enter a title!",
                          style: TextStyle(color: Colors.redAccent),
                        )
                        : null,
                label: Text(
                  "Title of the entry",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              onChanged: (value) {
                if (_titleController.text.isEmpty) {
                  setState(() {
                    _titleError = true;
                  });
                } else {
                  setState(() {
                    _titleError = false;
                  });
                }
              },
            ),

            /// For spacing
            const SizedBox(height: 10.0),

            /// Dropdown for type of the show
            DropdownButton<String>(
              value: _entryType,
              isExpanded: true,
              hint: const Text("Select type of the entry"),
              onChanged: (String? type) {
                setState(() => _entryType = type!);
              },
              items: _getEntryTypes(),
            ),

            /// For spacing
            const SizedBox(height: 10.0),

            /// Dropdown for priority of the show
            DropdownButton<int>(
              value: _selectedPriority,
              isExpanded: true,
              hint: const Text("Select priority of the entry"),
              onChanged: (int? priority) {
                setState(() => _selectedPriority = priority!);
              },
              items: Utils.getPriorityDropdown(),
            ),

            /// Checkbox to determine if the show is upcoming
            CheckboxListTile(
              title: Text("Upcoming"),
              value: _isUpcomingEntry,
              onChanged: (bool? newValue) {
                setState(() {
                  _isUpcomingEntry = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            /// Estimated release date
            Visibility(
              visible: _isUpcomingEntry,
              child: TextField(
                controller: _estimatedReleaseDateController,
                readOnly: true, // Prevent manual typing
                decoration: InputDecoration(
                  labelText: "Estimated release date",
                  suffixIcon: Icon(Icons.calendar_month_rounded),
                ),
                onTap: () => _selectDate(context), // Show date picker on tap
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
            Consumer<WatchlistEntryProvider>(
              builder: (context, provider, child) {
                return MaterialButton(
                  onPressed:
                      isSubmittable()
                          ? () => _createWatchlistEntry(provider, context)
                          : null,
                  child: Text(
                    "CREATE",
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
  void _createWatchlistEntry(
    WatchlistEntryProvider provider,
    BuildContext context,
  ) {
    WatchlistEntry entry = WatchlistEntry();
    entry.title = _titleController.text;
    // entry.category = _entryType!;
    entry.priority = _selectedPriority;
    entry.isUpcoming = _isUpcomingEntry;
    entry.estimatedReleaseDate =
        _isUpcomingEntry
            ? Utils.strDateToDateTime(_estimatedReleaseDateController.text)
            : null;

    provider.add(entry);
    Navigator.pop(context);
  }

  // TODO: Get the list from the database
  List<DropdownMenuItem<String>> _getEntryTypes() {
    List<String> showType = ["Movie", "Anime", "Series", "Sitcom"];

    return showType
        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
        .toList();
  }

  /// Show date picker popup
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _estimatedReleaseDateController.text = Utils.dateTimeToStrDate(picked);
      });
    }
  }

  /// Check the title, entry type, upcoming status and estimated release date
  bool isSubmittable() {
    if (_titleController.text.isNotEmpty && _entryType != null) {
      if (_isUpcomingEntry && _estimatedReleaseDateController.text.isEmpty) {
        return false;
      }

      return true;
    } else {
      return false;
    }
  }

}
