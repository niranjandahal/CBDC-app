import 'package:cbdc/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import "package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart";
import 'dashboard_screen.dart';
import 'transaction_history_screen.dart';
import 'settings_screen.dart';
import 'qrscan_page.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      DashboardScreen(),
      TransactionHistoryScreen(),
      QRScanPage(),
      NotificationsScreen(),
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.dashboard),
        title: "Dashboard",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.history),
        title: "History",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.qr_code_scanner,
          color: Colors.green,
          size: 33,
        ),
        title: "Scan",
        activeColorPrimary: Colors.green.withOpacity(0.2),
        inactiveColorPrimary: Colors.transparent,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.notification_important),
        title: "Notification",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: "Settings",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: Colors.white, // Default color for the bottom nav bar
      handleAndroidBackButtonPress: true, // Default is true
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      navBarStyle: NavBarStyle.style15, // Choose from the NavBarStyle
    );
  }
}
