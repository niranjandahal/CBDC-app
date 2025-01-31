import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/login_screen.dart';
import 'package:cbdc/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import "package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart";
import 'dashboard_screen.dart';
import 'transaction_history_screen.dart';
import 'settings_screen.dart';
import 'qrscan_page.dart';
import 'package:provider/provider.dart';
import 'package:cbdc/provider/theme_provider.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();

    // Ensure that user info is fetched when walletuserid is not empty
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Fetch user info if walletuserid is available
    if (userProvider.walletuserid.isNotEmpty) {
      userProvider.fetchUserInfo();
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // 👀 Fixes issue of multiple navbars persisting
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        if (value.walletuserid.isEmpty) {
          Future.microtask(() => PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: LoginScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              ));
          return SizedBox(); // Prevents UI errkrors while navigating
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      Colors.grey[900]!,
                      Colors.black,
                    ] // 👀 Apply dark gradient
                  : [
                      Colors.white,
                      Colors.white
                    ], // 👀 Keep white for light mode
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: PersistentTabView(
            animationSettings: NavBarAnimationSettings(),
            navBarHeight: 60,
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(isDarkMode),
            backgroundColor:
                Colors.transparent, // 👀 Makes the gradient visible
            handleAndroidBackButtonPress: false,
            resizeToAvoidBottomInset: true,
            stateManagement: false, // 👀 Prevents nav state from persisting
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar:
                  Colors.transparent, // 👀 Ensures gradient is visible
            ),
            navBarStyle: NavBarStyle.style15,
          ),
        );
      },
    );
  }

  List<Widget> _buildScreens() {
    return [
      DashboardScreen(),
      TransactionHistoryScreen(),
      QRScanPage(),
      NotificationsScreen(),
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(bool isDarkMode) {
    return [
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ],
        ),
        title: "Dashboard",
        activeColorPrimary: isDarkMode ? Colors.deepPurpleAccent : Colors.blue,
        inactiveColorPrimary: isDarkMode ? Colors.white54 : Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.history,
            color: isDarkMode ? Colors.white : Colors.black),
        title: "History",
        activeColorPrimary: isDarkMode ? Colors.deepPurpleAccent : Colors.blue,
        inactiveColorPrimary: isDarkMode ? Colors.white54 : Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.qr_code_scanner,
            color: isDarkMode ? Colors.greenAccent : Colors.green, size: 33),
        title: "Scan",
        activeColorPrimary: isDarkMode
            ? Colors.greenAccent.withOpacity(0.2)
            : Colors.green.withOpacity(0.2),
        inactiveColorPrimary: Colors.transparent,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.notification_important,
            color: isDarkMode ? Colors.white : Colors.black),
        title: "Notification",
        activeColorPrimary: isDarkMode ? Colors.deepPurpleAccent : Colors.blue,
        inactiveColorPrimary: isDarkMode ? Colors.white54 : Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings,
            color: isDarkMode ? Colors.white : Colors.black),
        title: "Settings",
        activeColorPrimary: isDarkMode ? Colors.deepPurpleAccent : Colors.blue,
        inactiveColorPrimary: isDarkMode ? Colors.white54 : Colors.grey,
      ),
    ];
  }
}
