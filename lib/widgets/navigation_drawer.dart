import 'package:flutter/material.dart';

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
                      children: const [
                        Text('Hello There', style: TextStyle(fontSize: 14)),
                        SizedBox(height: 4),
                        Text(
                          'Test User',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Menu Items
            Expanded(
              child: ListView(
                children: [
                  // Home Page
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.list_alt,
                    title: 'List',
                    badgeCount: 2,
                    selected: currentRoute == '/home',
                    routeTo: '/home',
                  ),

                  // Category Page
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.category_outlined,
                    title: 'Categories',
                    selected: currentRoute == '/entry-category',
                    badgeCount: 2,
                    badgeColor: Colors.red.shade200,
                    routeTo: '/entry-category',
                  ),

                  // Import Export Page
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.storage,
                    title: 'Backup & Restore',
                    selected: currentRoute == '/import-export',
                    routeTo: '/import-export',
                  ),

                  // Settings Page
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.settings,
                    title: 'Settings',
                    selected: currentRoute == '/settings',
                    routeTo: '/settings',
                  ),
                ],
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
    Color badgeColor = const Color(0xFFBDB4FE), // Default light purple
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
            Navigator.pop(context); // just close drawer if already on that page
          }
        },
      ),
    );
  }
}
