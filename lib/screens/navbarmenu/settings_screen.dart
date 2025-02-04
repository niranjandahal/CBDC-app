import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/utils/setuptranscpin.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
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
          // const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => _logout(context), // 👀 Calls logout function
          ),
          ListTile(
              leading: const Icon(Icons.input),
              title: const Text("Setup Transcation Pin"),
              onTap: () => PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: SetupTransactionPin(),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  ) //👀 Calls logout function
              ),
        ],
      ),
    );
  }
}
