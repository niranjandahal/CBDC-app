import 'package:cbdc/provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  void _logout(context) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);

    userprovider.logout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => _logout(context), // 👀 Calls logout function
          ),
        ],
      ),
    );
  }
}
