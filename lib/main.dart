import 'package:cbdc/screens/login_screen.dart';
import 'package:cbdc/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cbdc/themes/theme_provider.dart';
import 'package:cbdc/themes/app_theme.dart';

void main() {
  runApp(CBDCApp());
}

class CBDCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkMode
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            home: AuthHandler(),
          );
        },
      ),
    );
  }
}

class AuthHandler extends StatefulWidget {
  @override
  _AuthHandlerState createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginState();
  }

  Future<void> checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear saved login state
    setState(() {
      isLoggedIn = false; // Redirect to LoginScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? MainNavigation() // Pass logout function here
        : LoginScreen();
  }
}
