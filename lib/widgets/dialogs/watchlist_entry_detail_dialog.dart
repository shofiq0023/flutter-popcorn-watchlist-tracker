import 'package:flutter/material.dart';
import 'package:popcorn/enums/watchlist_entry_type.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/utils/utils.dart';
import 'package:provider/provider.dart';

class WatchlistEntryDetailDialog extends StatefulWidget {
  final WatchlistEntry watchlistEntry;
  const WatchlistEntryDetailDialog({super.key, required this.watchlistEntry});

  @override
  State<WatchlistEntryDetailDialog> createState() => _WatchlistEntryDetailDialogState();
}

class _WatchlistEntryDetailDialogState extends State<WatchlistEntryDetailDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _estimatedReleaseDateController = TextEditingController();
  final TextEditingController _entryFinishedDateController = TextEditingController();
  final TextEditingController _entryCreationDateController = TextEditingController();
  final TextEditingController _entryUpdateDateController = TextEditingController();

  bool _titleError = false;
  bool _isUpcomingEntry = false;
  String? _entryType;
  int _selectedPriority = 3;
  bool _isEntryFinished = false;
  bool _isEntryRecommendable = false;

  @override
  void initState() {
    WatchlistEntry entry = widget.watchlistEntry;
    _titleController.text = entry.title;
    _entryType = entry.type;
    _selectedPriority = entry.priority;
    _isEntryRecommendable = entry.isRecommendable;

    _isUpcomingEntry = entry.isUpcoming;
    _estimatedReleaseDateController.text = Utils.dateTimeToStrDate(entry.estimatedReleaseDate);

    _isEntryFinished = entry.isFinished;
    _entryFinishedDateController.text = Utils.dateTimeToStrDate(entry.finishedAt);

    _entryCreationDateController.text = Utils.dateTimeToStrDateWithTime(entry.createdAt);
    _entryUpdateDateController.text = Utils.dateTimeToStrDateWithTime(entry.updatedAt);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Details of the entry"),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
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
          
              /// Recommendable entry checkbox
              CheckboxListTile(
                title: Text("Recommendable"),
                value: _isEntryRecommendable,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isEntryRecommendable = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
          
              /// Upcoming entry checkbox
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
          
              /// Estimated release date based on upcoming status
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
          
              /// For spacing
              const SizedBox(height: 25.0),
          
              /// Entry finished date
              Visibility(
                visible: _isEntryFinished,
                child: TextField(
                  controller: _entryFinishedDateController,
                  readOnly: true, // Prevent manual typing
                  decoration: InputDecoration(
                      labelText: "Finished date",
                      border: InputBorder.none
                  ),
                ),
              ),
          
              /// Entry creation date
              TextField(
                controller: _entryCreationDateController,
                readOnly: true, // Prevent manual typing
                decoration: InputDecoration(
                    labelText: "Created at",
                    border: InputBorder.none
                ),
              ),
          
              /// Entry update date
              Visibility(
                visible: _entryUpdateDateController.text.isNotEmpty,
                child: TextField(
                  controller: _entryUpdateDateController,
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
                      ? () => _updateWatchlistEntry(provider, context)
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

  /// Add a new entry to the database
  void _updateWatchlistEntry(WatchlistEntryProvider provider, BuildContext context) {
    WatchlistEntry entry = widget.watchlistEntry;
    entry.title = _titleController.text;
    entry.type = _entryType!;
    entry.priority = _selectedPriority;
    entry.isRecommendable = _isEntryRecommendable;

    entry.isUpcoming = _isUpcomingEntry;
    entry.estimatedReleaseDate = _isUpcomingEntry ? Utils.strDateToDateTime(_estimatedReleaseDateController.text) : null;

    provider.update(entry);
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
