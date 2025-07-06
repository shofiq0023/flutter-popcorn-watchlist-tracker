import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onIndexSelected;
  const CustomBottomNavigationBar({super.key, required this.onIndexSelected});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          // labelTextStyle: MaterialStateProperty.all(
          //   TextStyle(color: CustomColors.offwhite),
          // ),
        ),
        child: NavigationBar(
          // indicatorColor: navBarSelectedColor,
          // backgroundColor: navBarBg,
          selectedIndex: pageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              pageIndex = index;
            });

            // Calls the index passing function
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
        icon: Icon(
          Icons.list,
          // color: getIconColor(currentIndex: pageIndex, targetIndex: 0),
        ),
        label: 'Watch List',
      ),
      NavigationDestination(
        selectedIcon: const Icon(Icons.featured_play_list),
        icon: Icon(
          Icons.playlist_add_check,
          // color: getIconColor(currentIndex: pageIndex, targetIndex: 1),
        ),
        label: 'Finished',
      )
    ];
  }
}
