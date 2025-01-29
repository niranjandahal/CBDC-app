import 'package:cbdc/screens/login_screen.dart';
import 'package:flutter/material.dart';
// import 'package:cbdc/services/shared_prefs_helper.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Divider(),
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false);
            },
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }
}
