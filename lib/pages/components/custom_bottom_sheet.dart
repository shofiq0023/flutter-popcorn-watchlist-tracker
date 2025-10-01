import 'package:flutter/material.dart';
import 'package:popcorn/providers/entry_category_provider.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:provider/provider.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({super.key});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Set<String> selectedItems = {};

  final List<Map<String, String>> sortingParameters = [
    {'default': 'Priority (High to Normal) [Default]'},
    {'priority_desc': 'Priority (Normal to High)'},
    {'title_asc': 'Title (A-Z)'},
    {'title_desc': 'Title (Z-A)'},
    {'date_desc': 'Creation Date (New to Old)'},
    {'date_asc': 'Creation Date (Old to New)'},
  ];

  final List<String> multiSelectItems = [
    'Option A',
    'Option B',
    'Option C',
    'Option D',
    'Option E',
    'Option F',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Sort & Filter',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [Tab(text: 'Sort'), Tab(text: 'Filter')],
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildSingleSelectTab(), _buildMultiSelectTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleSelectTab() {
    return Consumer<WatchlistEntryProvider>(
      builder: (context, watchlistProvider, child) {
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: sortingParameters.length,
          itemBuilder: (context, index) {
            final item = sortingParameters[index];
            final key = item.keys.first;
            final value = item.values.first;
            final isSelected = _isCurrentSortingOption(
              watchlistProvider.currentSortType,
              key,
            );

            return Card(
              color: isSelected ? Colors.blue.shade50 : null,
              elevation: isSelected ? 3 : 1,
              child: ListTile(
                title: Text(
                  value,
                  style: TextStyle(
                    color: isSelected ? Colors.blue.shade700 : null,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                trailing: Icon(
                  isSelected ? Icons.check : Icons.arrow_forward_ios,
                  size: 16,
                  color: isSelected ? Colors.blue.shade700 : null,
                ),
                onTap: () {
                  watchlistProvider.sortWatchlist(key);
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }

  bool _isCurrentSortingOption(String currentSortType, String item) {
    return currentSortType == item;
  }

  Widget _buildMultiSelectTab() {
    return Consumer2<WatchlistEntryProvider, EntryCategoryProvider>(
      builder: (context, watchlistProvider, entryCategoryProvider, child) {
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: entryCategoryProvider.filterOptions.length,
          itemBuilder: (context, index) {
            final item = entryCategoryProvider.filterOptions[index];
            final isSelected = watchlistProvider.selectedFilterOptionsContains(item);

            return Card(
              child: CheckboxListTile(
                title: Text(item),
                value: isSelected,
                onChanged: (bool? value) {
                  if (value == true) {
                    watchlistProvider.addToFilterOption(item);
                  } else {
                    watchlistProvider.removeFromFilterOption(item);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
