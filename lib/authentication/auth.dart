import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cbdc/screens/main_navigation.dart';
import 'package:cbdc/screens/login_screen.dart';

class AuthHandler extends StatefulWidget {
  @override
  _AuthHandlerState createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {
  bool isLoggedIn = false;
  bool isLoading = true; // ✅ Prevent UI flicker while checking login state

  @override
  void initState() {
    super.initState();
    checkLoginState();
  }

  Future<void> checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final walletId =
        prefs.getString("wallet_id"); // ✅ Check if user is logged in

    setState(() {
      isLoggedIn = walletId != null; // ✅ True if logged in, False if not
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
          body: Center(
              child:
                  CircularProgressIndicator())); // ✅ Show loading while checking login state
    }
    return isLoggedIn ? MainNavigation() : LoginScreen();
  }
}
