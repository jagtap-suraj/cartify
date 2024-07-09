import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/features/auth/screens/home_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentPageIndex = 0;
  static const double _iconSize = 28;
  static const double _borderWidth = 5;
  static const double _badgeTopPosition = -16;
  static const double _badgeEndPosition = -3;
  static const double _badgeContainerWidth = 42;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('Profile Screen')),
    const Center(child: Text('Cart Screen')),
  ];

  // This function sets the top line color of the selected icon
  void _updatePage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: _iconSize,
        onTap: _updatePage,
        items: [
          _buildBottomNavItem(Icons.home_outlined, 0),
          _buildBottomNavItem(Icons.person_outline_outlined, 1),
          _buildBottomNavItemWithBadge(Icons.shopping_cart_outlined, 2, '3'),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(IconData icon, int pageIndex) {
    return BottomNavigationBarItem(
      label: '',
      icon: Container(
        width: _badgeContainerWidth,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _currentPageIndex == pageIndex ? GlobalVariables.selectedNavBarColor : GlobalVariables.backgroundColor,
              width: _borderWidth,
            ),
          ),
        ),
        child: Icon(icon),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItemWithBadge(IconData icon, int pageIndex, String badgeContent) {
    return BottomNavigationBarItem(
      label: '',
      icon: Container(
        width: 42,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _currentPageIndex == pageIndex ? GlobalVariables.selectedNavBarColor : GlobalVariables.backgroundColor,
              width: _borderWidth,
            ),
          ),
        ),
        child: badges.Badge(
          position: badges.BadgePosition.topEnd(top: _badgeTopPosition, end: _badgeEndPosition),
          badgeContent: Text(
            badgeContent,
            style: const TextStyle(color: Colors.white),
          ),
          badgeStyle: badges.BadgeStyle(
            shape: badges.BadgeShape.circle,
            padding: const EdgeInsets.all(6),
            borderRadius: BorderRadius.circular(4),
            elevation: 0,
            badgeColor: GlobalVariables.selectedNavBarColor,
          ),
          child: Icon(icon),
        ),
      ),
    );
  }
}
