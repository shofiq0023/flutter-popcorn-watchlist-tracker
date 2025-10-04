import 'package:flutter/material.dart';
import 'package:popcorn/providers/entry_category_provider.dart'; // Your other provider
import 'package:popcorn/providers/user_preferences_provider.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/widgets/dialogs/user_preferences/username_create_dialog.dart';
import 'package:provider/provider.dart';
import 'package:popcorn/utils/global_const.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: Color(0xFF1D193A),
      child: SafeArea(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 30.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello There,', style: TextStyle(fontSize: 16, color: GlobalConst.whiteColor)),
                        SizedBox(height: 4),
                        Consumer<UserPreferencesProvider>(
                          builder: (context, userPreferences, child) {
                            return FutureBuilder<String>(
                              future: userPreferences.username, // async getter
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text(
                                    'Error: ${snapshot.error}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: () {
                                      showUsernameInputDialog(context, snapshot.data ?? '');
                                    },
                                    child: Text(
                                      snapshot.data ?? '',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: GlobalConst.whiteColor
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Multiple Providers here using Consumer2
            Expanded(
              child: Consumer2<WatchlistEntryProvider, EntryCategoryProvider>(
                builder: (context, watchlistProvider, categoryProvider, child) {
                  return ListView(
                    children: [
                      // Home page
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.list_alt,
                        title: 'Watch List',
                        badgeCount: watchlistProvider.entryCount(),
                        selected: currentRoute == '/home',
                        routeTo: '/home',
                      ),

                      // Category Page
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.category_outlined,
                        title: 'Categories',
                        badgeCount: categoryProvider.getCategoriesCount(),
                        // example for category count
                        badgeColor: Colors.red.shade200,
                        selected: currentRoute == '/entry-category',
                        routeTo: '/entry-category',
                      ),

                      // Backup and restore page
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.storage,
                        title: 'Backup & Restore',
                        selected: currentRoute == '/import-export',
                        routeTo: '/import-export',
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required context,
    required IconData icon,
    required String title,
    int badgeCount = 0,
    bool selected = false,
    Color badgeColor = const Color(0xFFBDB4FE),
    routeTo = '/home',
  }) {
    return Container(
      color:
          selected
              ? GlobalConst.whiteColor.withValues(alpha: 0.9)
              : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: selected ? const Color(0xFF090812) : GlobalConst.whiteColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? Color(0xFF090812) : GlobalConst.whiteColor,
          ),
        ),
        trailing:
            badgeCount > 0
                ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : null,
        onTap: () {
          if (ModalRoute.of(context)?.settings.name != routeTo) {
            Navigator.pushReplacementNamed(context, routeTo);
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  void showUsernameInputDialog(BuildContext context, String username) {
    showDialog(context: context, builder: (context) => UsernameCreateDialog(username: username,));
  }
}
