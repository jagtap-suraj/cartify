import 'package:badges/badges.dart' as badges;
import 'package:cartify/features/account/screens/account_screen.dart';
import 'package:cartify/features/cart/screens/cart_screen.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/features/home/screens/home_screen.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  /// The _currentPageIndex variable tracks the currently selected page in the bottom navigation bar
  /// Initially set to 0, it corresponds to the first screen in the _screens list.
  /// When a bottom navigation item is tapped, _updatePage is called with the index of the tapped item.
  /// This function updates _currentPageIndex with the new index and calls setState to rebuild the widget
  /// thus displayin the newly selected page.
  /// The BottomNavigationBar uses _currentPageIndex to highlight the currently active item.
  int _currentPageIndex = 0;
  static const double _iconSize = 28;
  static const double _borderWidth = 5;
  static const double _badgeTopPosition = -16;
  static const double _badgeEndPosition = -3;
  static const double _badgeContainerWidth = 42;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];

  /// Sets the top line color of the selected icon
  void _updatePage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLength = context.watch<UserProvider>().user.cart?.length ?? 7;
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
          _buildBottomNavItemWithBadge(Icons.shopping_cart_outlined, 2, userCartLength.toString()),
        ],
      ),
    );
  }

  /// Creates a navigation bar item without a badge i.e. the home and profile icons
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

  /// Creates a navigation bar item with a badge i.e. the cart icon
  BottomNavigationBarItem _buildBottomNavItemWithBadge(IconData icon, int pageIndex, String badgeContent) {
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
