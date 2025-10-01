import 'package:flutter/material.dart';
import 'package:popcorn/providers/entry_category_provider.dart'; // Your other provider
import 'package:popcorn/providers/user_preferences_provider.dart';
import 'package:popcorn/providers/watchlist_entry_provider.dart';
import 'package:popcorn/widgets/dialogs/user_preferences/username_create_dialog.dart';
import 'package:provider/provider.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello There', style: TextStyle(fontSize: 14)),
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
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
            const Divider(),

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
                        title: 'List',
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

                      // Settings page
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.settings,
                        title: 'Settings',
                        selected: currentRoute == '/settings',
                        routeTo: '/settings',
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
              ? const Color(0xFF6C63FF).withValues(alpha: 0.2)
              : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: selected ? const Color(0xFF6C63FF) : Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? const Color(0xFF6C63FF) : Colors.black,
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
