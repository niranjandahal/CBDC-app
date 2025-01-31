import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/login_screen.dart';
import 'package:cbdc/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, value, child) =>
            value.walletuserid.isEmpty ? LoginScreen() : MainNavigation(),
      ),
    );
  }
}
