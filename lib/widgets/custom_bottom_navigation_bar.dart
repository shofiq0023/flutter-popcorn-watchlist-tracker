import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onIndexSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onIndexSelected,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), blurRadius: 10),
        ],
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(),
        child: NavigationBar(
          selectedIndex: widget.selectedIndex,
          onDestinationSelected: (int index) {
            widget.onIndexSelected(index);
          },
          destinations: getBottomNavList(),
        ),
      ),
    );
  }

  List<NavigationDestination> getBottomNavList() {
    return [
      NavigationDestination(
        selectedIcon: const Icon(Icons.list_alt),
        icon: Icon(Icons.list),
        label: 'Watch List',
      ),
      NavigationDestination(
        selectedIcon: const Icon(Icons.fact_check),
        icon: Icon(Icons.playlist_add_check),
        label: 'Finished',
      ),
    ];
  }
}
