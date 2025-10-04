import 'package:flutter/material.dart';
import 'package:popcorn/utils/global_const.dart';

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
        border: Border(top: BorderSide(color: GlobalConst.blackColor)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            offset: Offset(0, -3),
            blurRadius: 8,
            spreadRadius: 5,
          ),
        ],
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Color(0xFF1D193A),
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(color: GlobalConst.whiteColor),
          ),
        ),
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
        selectedIcon: const Icon(Icons.list_alt, color: Color(0xFF090812)),
        icon: Icon(Icons.list, color: GlobalConst.whiteColor),
        label: 'Watch List',
      ),
      NavigationDestination(
        selectedIcon: const Icon(Icons.fact_check, color: Color(0xFF090812)),
        icon: Icon(Icons.playlist_add_check, color: GlobalConst.whiteColor),
        label: 'Finished',
      ),
    ];
  }
}
