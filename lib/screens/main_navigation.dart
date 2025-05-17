import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/navbarmenu/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'navbarmenu/dashboard_screen.dart';
import 'navbarmenu/transaction_history_screen.dart';
import 'navbarmenu/settings_screen.dart';
import 'utils/qrscan_page.dart';
import 'package:provider/provider.dart';
import 'package:cbdc/provider/theme_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

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

    print(
        "IIIIIIIIIIIIIINNNNNNNNNNNIIIIIIITTTT SSSSTTTAAAAAAATTTTTTTEEE CCCCCAAAAALLLLLLLLLEEEEEEEDD");
    final userProvider = Provider.of<UserProvider>(context, listen: false);
//
    // Fetch user info if walletuserid is available
//
    print("PPPrrrINting WAllet user id before man nva is loaded : ::::::::");
    print(userProvider.walletuserid);
    print("si there wallet id");
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
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/': (context) => DashboardScreen(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.history,
            color: isDarkMode ? Colors.white : Colors.black),
        title: "History",
        activeColorPrimary: isDarkMode ? Colors.deepPurpleAccent : Colors.blue,
        inactiveColorPrimary: isDarkMode ? Colors.white54 : Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/': (context) => TransactionHistoryScreen(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.qr_code_scanner,
            color: isDarkMode ? Colors.greenAccent : Colors.green, size: 33),
        title: "Scan",
        activeColorPrimary: isDarkMode
            ? Colors.greenAccent.withOpacity(0.2)
            : Colors.green.withOpacity(0.2),
        inactiveColorPrimary: Colors.transparent,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/': (context) => QRScanPage(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.notification_important,
            color: isDarkMode ? Colors.white : Colors.black),
        title: "Notification",
        activeColorPrimary: isDarkMode ? Colors.deepPurpleAccent : Colors.blue,
        inactiveColorPrimary: isDarkMode ? Colors.white54 : Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/': (context) => NotificationsScreen(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings,
            color: isDarkMode ? Colors.white : Colors.black),
        title: "Settings",
        activeColorPrimary: isDarkMode ? Colors.deepPurpleAccent : Colors.blue,
        inactiveColorPrimary: isDarkMode ? Colors.white54 : Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/': (context) => SettingsScreen(),
          },
        ),
      ),
    ];
  }
}
