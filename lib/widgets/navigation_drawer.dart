import 'package:flutter/material.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=3', // Replace with actual profile image
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Ashfak Sayem',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ashfaksayem@gmail.com',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
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
                  _buildDrawerItem(
                    icon: Icons.calendar_today,
                    title: 'Calendar',
                    badgeCount: 2,
                    selected: true,
                  ),
                  _buildDrawerItem(
                    icon: Icons.card_giftcard,
                    title: 'Rewards',
                    badgeCount: 2,
                    badgeColor: Colors.red.shade200,
                  ),
                  _buildDrawerItem(
                    icon: Icons.location_on,
                    title: 'Address',
                  ),
                  _buildDrawerItem(
                    icon: Icons.payment,
                    title: 'Payments Methods',
                  ),
                  _buildDrawerItem(
                    icon: Icons.local_offer,
                    title: 'Offers',
                    badgeCount: 2,
                    badgeColor: Colors.green.shade200,
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_add,
                    title: 'Refer a Friend',
                  ),
                  _buildDrawerItem(
                    icon: Icons.support_agent,
                    title: 'Support',
                  ),
                ],
              ),
            ),

            // Color Scheme Switch
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.color_lens_outlined, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Colour Scheme',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Center(
                              child: Text(
                                'Light',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.dark_mode, size: 16),
                                  SizedBox(width: 4),
                                  Text('Dark'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
    required IconData icon,
    required String title,
    int badgeCount = 0,
    bool selected = false,
    Color badgeColor = const Color(0xFFBDB4FE), // Default light purple
  }) {
    return Container(
      color: selected ? const Color(0xFF6C63FF).withOpacity(0.2) : Colors.transparent,
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
        trailing: badgeCount > 0
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
        onTap: () {},
      ),
    );
  }
}
