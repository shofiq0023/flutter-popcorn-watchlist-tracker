import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/models/entities/watchlist_entry.dart';
import 'package:popcorn/providers/entry_category_provider.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/utils/global_const.dart';
import 'package:popcorn/utils/toast_helper.dart';
import 'package:popcorn/utils/utils.dart';
import 'package:provider/provider.dart';

class WatchlistEntryCreateDialog extends StatefulWidget {
  const WatchlistEntryCreateDialog({super.key});

  @override
  State<WatchlistEntryCreateDialog> createState() =>
      _WatchlistEntryCreateDialogState();
}

class _WatchlistEntryCreateDialogState
    extends State<WatchlistEntryCreateDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _estimatedReleaseDateController =
      TextEditingController();

  bool _titleError = false;
  bool _isUpcomingEntry = false;
  EntryCategory? _selectedCategory;
  int _selectedPriority = 3;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Create a new entry",
        style: TextStyle(color: GlobalConst.whiteColor),
      ),
      backgroundColor: GlobalConst.dialogBoxBg,
      content: SizedBox(
        width: 600,
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
                  hint: const Text(
                    "Select entry category",
                    style: TextStyle(color: Color(0xFFCAC1FF)),
                  ),
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
              hint: const Text(
                "Select priority of the entry",
                style: TextStyle(color: Color(0xFFCAC1FF)),
              ),
              onChanged: (int? priority) {
                setState(() => _selectedPriority = priority!);
              },
              items: Utils.getPriorityDropdown(),
            ),

            /// Checkbox to determine if the show is upcoming
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

            /// Estimated release date
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
          ],
        ),
      ),

      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// Close button
            MaterialButton(
              child: const Text(
                "CLOSE",
                style: TextStyle(color: GlobalConst.whiteColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            /// Create button
            Consumer<WatchlistEntryProvider>(
              builder: (context, provider, child) {
                return MaterialButton(
                  onPressed: () {
                    if (isSubmittable()) {
                      _createWatchlistEntry(provider, context);
                    } else {
                      ToastHelper.showWarningToast(
                        "Please fill out all fields!",
                      );
                    }
                  },
                  child: Text(
                    "CREATE",
                    style: TextStyle(
                      color: isSubmittable() ? Color(0xFF059669) : Colors.grey,
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
    entry.category.target = _selectedCategory!;
    entry.priority = _selectedPriority;
    entry.isUpcoming = _isUpcomingEntry;
    entry.estimatedReleaseDate =
        _isUpcomingEntry
            ? Utils.strDateToDateTime(_estimatedReleaseDateController.text)
            : null;

    provider.add(entry);
    ToastHelper.showSuccessToast("Successfully added entry to watchlist");
    Navigator.pop(context);
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
