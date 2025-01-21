import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cbdc/services/shared_prefs_helper.dart';
import 'main_navigation.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> login(BuildContext context) async {
    // Simulate login and save state
    SharedPrefsHelper.saveWalletId("user_wallet_id");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainNavigation()),
    );
  }

  // Future<void> biometricLogin(BuildContext context) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final isBiometricEnabled = prefs.getBool("isBiometricEnabled") ?? false;

  //   if (isBiometricEnabled) {
  //     bool authenticated = await auth.authenticate(
  //       localizedReason: "Authenticate to login",
  //       options: const AuthenticationOptions(biometricOnly: true),
  //     );
  //     if (authenticated) {
  //       await prefs.setBool("isLoggedIn", true);
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => MainNavigation()),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => login(context),
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
