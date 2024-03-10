import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GNav(
      backgroundColor: Colors.black,
      rippleColor:Colors.black,
      hoverColor: Color.fromARGB(255, 58, 53, 53),
      haptic: true,
      tabBorderRadius: 12,
      // tabActiveBorder: Border.all(color: Colors.black, width: 1),
     // tabBorder: Border.all(color: Colors.black, width: 1),
      //tabShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 6)],
      curve: Curves.easeOutExpo,
      duration: Duration(milliseconds: 800),
      gap: 8,
      color: Colors.white,
      activeColor: Colors.white,
      iconSize: 24,
      tabBackgroundColor: Color.fromARGB(255, 20, 16, 16),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      tabs: [
        GButton(
          icon: LineIcons.home,
          text: 'Home',
        ),
        // GButton(
        //   icon: Icons.info,
        // text: 'Facts'),
        GButton(
          icon: Icons.sensors,
          text: 'Sensor',
        ),
        GButton(
          icon: Icons.image_search,
          text: 'Search',
        ),
        GButton(
          icon: LineIcons.user,
          text: 'Profile',
        ),
        
      ],
      selectedIndex: selectedIndex,
      onTabChange: onTabChange,
    );
  }
}
