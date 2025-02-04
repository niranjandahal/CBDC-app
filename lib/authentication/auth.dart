import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/auth/login_screen.dart';
import 'package:cbdc/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  void initState() {
    UserProvider().checkLoginState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future:
            Provider.of<UserProvider>(context, listen: false).checkLoginState(),
        builder: (context, snapshot) {
          // If loading, show a progress indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there is an error, show the error message
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If snapshot data is true, navigate to MainNavigation, else LoginScreen
          if (snapshot.hasData && snapshot.data == true) {
            return MainNavigation();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
