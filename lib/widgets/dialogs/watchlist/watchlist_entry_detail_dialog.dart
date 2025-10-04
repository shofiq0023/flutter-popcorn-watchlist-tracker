import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/providers/entry_category_provider.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/utils/global_const.dart';
import 'package:popcorn/utils/toast_helper.dart';
import 'package:popcorn/utils/utils.dart';
import 'package:popcorn/widgets/dialogs/watchlist/delete_confirmation_dialog.dart';
import 'package:provider/provider.dart';

class WatchlistEntryDetailDialog extends StatefulWidget {
  final WatchlistEntry watchlistEntry;

  const WatchlistEntryDetailDialog({super.key, required this.watchlistEntry});

  @override
  State<WatchlistEntryDetailDialog> createState() =>
      _WatchlistEntryDetailDialogState();
}

class _WatchlistEntryDetailDialogState
    extends State<WatchlistEntryDetailDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _estimatedReleaseDateController =
      TextEditingController();
  final TextEditingController _entryFinishedDateController =
      TextEditingController();
  final TextEditingController _entryCreationDateController =
      TextEditingController();
  final TextEditingController _entryUpdateDateController =
      TextEditingController();

  bool _titleError = false;
  bool _isUpcomingEntry = false;
  EntryCategory? _selectedCategory;
  int _selectedPriority = 3;
  bool _isEntryFinished = false;
  bool _isEntryRecommendable = false;

  @override
  void initState() {
    WatchlistEntry entry = widget.watchlistEntry;
    _titleController.text = entry.title;
    _selectedCategory = entry.category.target;
    _selectedPriority = entry.priority;
    _isEntryRecommendable = entry.isRecommendable;
    _isEntryFinished = entry.isFinished;

    _isUpcomingEntry = entry.isUpcoming;
    _estimatedReleaseDateController.text = Utils.dateTimeToStrDate(
      entry.estimatedReleaseDate,
    );

    _entryFinishedDateController.text = Utils.dateTimeToStrDate(
      entry.finishedAt,
    );

    _entryCreationDateController.text = Utils.dateTimeToStrDateWithTime(
      entry.createdAt,
    );
    _entryUpdateDateController.text = Utils.dateTimeToStrDateWithTime(
      entry.updatedAt,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Details of the entry",
        style: TextStyle(color: GlobalConst.whiteColor),
      ),
      backgroundColor: GlobalConst.dialogBoxBg,
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
                style: const TextStyle(color: GlobalConst.whiteColor),
                decoration: InputDecoration(
                  error:
                      _titleError
                          ? const Text(
                            "Please enter a title!",
                            style: TextStyle(color: GlobalConst.redColor),
                          )
                          : null,
                  label: Text(
                    "Title of the entry",
                    style: TextStyle(fontSize: 16.0, color: Color(0xFFCAC1FF)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: GlobalConst.whiteColor,
                    ), // Normal state
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
              FutureBuilder<List<EntryCategory>>(
                future:
                    Provider.of<EntryCategoryProvider>(
                      context,
                      listen: false,
                    ).categoryList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  List<EntryCategory> categories = snapshot.data!;

                  // Fix: Find matching object in the new list by ID
                  EntryCategory? currentValue;

                  try {
                    currentValue =
                        _selectedCategory == null
                            ? null
                            : categories.firstWhere(
                              (cat) => cat.id == _selectedCategory!.id,
                            );
                  } catch (e) {
                    currentValue = null;
                  }

                  return DropdownButton<EntryCategory>(
                    style: TextStyle(color: GlobalConst.whiteColor, fontSize: 16),
                    iconEnabledColor: GlobalConst.whiteColor,
                    underline: Container(height: 1, color: GlobalConst.whiteColor),
                    dropdownColor: Color(0xFF090812),
                    value: currentValue,
                    isExpanded: true,
                    hint: const Text("Select entry category"),
                    onChanged: (EntryCategory? category) {
                      setState(() => _selectedCategory = category);
                    },
                    items:
                        categories.map((c) {
                          return DropdownMenuItem<EntryCategory>(
                            value: c,
                            child: Text(c.categoryName),
                          );
                        }).toList(),
                  );
                },
              ),

              /// For spacing
              const SizedBox(height: 10.0),

              /// Dropdown for priority of the show
              DropdownButton<int>(
                style: TextStyle(color: GlobalConst.whiteColor, fontSize: 16),
                iconEnabledColor: GlobalConst.whiteColor,
                underline: Container(height: 1, color: GlobalConst.whiteColor),
                dropdownColor: Color(0xFF090812),
                value: _selectedPriority,
                isExpanded: true,
                hint: const Text("Select priority of the entry"),
                onChanged: (int? priority) {
                  setState(() => _selectedPriority = priority!);
                },
                items: Utils.getPriorityDropdown(),
              ),

              /// isFinished entry checkbox
              CheckboxListTile(
                title: Text(
                  "Finished",
                  style: TextStyle(color: GlobalConst.whiteColor),
                ),
                value: _isEntryFinished,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isEntryFinished = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                checkColor: GlobalConst.whiteColor,
                side: BorderSide(
                  color: GlobalConst.whiteColor, // Border color when unchecked
                  width: 2,
                ),
              ),

              /// Recommendable entry checkbox
              CheckboxListTile(
                title: Text(
                  "Recommendable",
                  style: TextStyle(color: GlobalConst.whiteColor),
                ),
                value: _isEntryRecommendable,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isEntryRecommendable = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                checkColor: GlobalConst.whiteColor,
                // Checkmark color
                side: BorderSide(
                  color: GlobalConst.whiteColor, // Border color when unchecked
                  width: 2,
                ),
              ),

              /// Upcoming entry checkbox
              CheckboxListTile(
                title: Text(
                  "Upcoming",
                  style: TextStyle(color: GlobalConst.whiteColor),
                ),
                value: _isUpcomingEntry,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isUpcomingEntry = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                checkColor: GlobalConst.whiteColor,
                // Checkmark color
                side: BorderSide(
                  color: GlobalConst.whiteColor, // Border color when unchecked
                  width: 2,
                ),
              ),

              /// Estimated release date based on upcoming status
              Visibility(
                visible: _isUpcomingEntry,
                child: TextField(
                  style: const TextStyle(color: GlobalConst.whiteColor),
                  controller: _estimatedReleaseDateController,
                  readOnly: true,
                  // Prevent manual typing
                  decoration: InputDecoration(
                    labelText: "Estimated release date",
                    labelStyle: TextStyle(color: GlobalConst.whiteColor),
                    suffixIcon: Icon(
                      Icons.calendar_month_rounded,
                      color: GlobalConst.whiteColor,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: GlobalConst.whiteColor),
                    ),
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
                  style: const TextStyle(color: GlobalConst.whiteColor),
                  controller: _entryFinishedDateController,
                  readOnly: true, // Prevent manual typing
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: GlobalConst.whiteColor),
                    labelText: "Finished date",
                    border: InputBorder.none,
                  ),
                ),
              ),

              /// Entry creation date
              TextField(
                style: const TextStyle(color: GlobalConst.whiteColor),
                controller: _entryCreationDateController,
                readOnly: true, // Prevent manual typing
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: GlobalConst.whiteColor),
                  labelText: "Created at",
                  border: InputBorder.none,
                ),
              ),

              /// Entry update date
              Visibility(
                visible: _entryUpdateDateController.text.isNotEmpty,
                child: TextField(
                  controller: _entryUpdateDateController,
                  style: const TextStyle(color: GlobalConst.whiteColor),
                  readOnly: true, // Prevent manual typing
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: GlobalConst.whiteColor),
                    labelText: "Last updated at",
                    border: InputBorder.none,
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
            /// Update button
            Consumer<WatchlistEntryProvider>(
              builder: (context, provider, child) {
                return MaterialButton(
                  onPressed: () {
                    _deleteWatchlistEntry(provider, context);
                  },
                  child: Text(
                    "DELETE",
                    style: TextStyle(color: GlobalConst.redColor),
                  ),
                );
              },
            ),
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
                      color: isSubmittable() ? GlobalConst.greenColor : Colors.grey,
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
  void _updateWatchlistEntry(
    WatchlistEntryProvider provider,
    BuildContext context,
  ) {
    WatchlistEntry entry = widget.watchlistEntry;
    entry.title = _titleController.text;
    entry.category.target = _selectedCategory!;
    entry.priority = _selectedPriority;
    entry.isFinished = _isEntryFinished;
    entry.isRecommendable = _isEntryRecommendable;

    entry.isUpcoming = _isUpcomingEntry;
    entry.estimatedReleaseDate =
        _isUpcomingEntry
            ? Utils.strDateToDateTime(_estimatedReleaseDateController.text)
            : null;

    provider.update(entry);
    ToastHelper.showSuccessToast("Successfully updated entry");
    Navigator.pop(context);
  }

  /// Delete the current entry
  void _deleteWatchlistEntry(
    WatchlistEntryProvider provider,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder:
          (context) =>
              DeleteConfirmationDialog(watchlistEntry: widget.watchlistEntry),
    );
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
    if (_titleController.text.isNotEmpty && _selectedCategory != null) {
      if (_isUpcomingEntry && _estimatedReleaseDateController.text.isEmpty) {
        return false;
      }

      return true;
    } else {
      return false;
    }
  }
}
