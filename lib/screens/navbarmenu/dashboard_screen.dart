import 'package:cbdc/provider/theme_provider.dart';
import 'package:cbdc/screens/transcations/recenttranscation.dart';
// import 'package:cbdc/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import '../../widgets/balance_card.dart';
import '../utils/send_money_screen.dart';
import '../utils/receive_money_screen.dart';
import '../utils/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("CBDC Wallet"),
        actions: [
          // Dark Mode Toggle
          IconButton(
            icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Use reusable BalanceCard
              BalanceCard(),
              const SizedBox(height: 30),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton(
                    context,
                    "Send Money",
                    Icons.send,
                    Colors.blue,
                    () => PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: SendMoneyScreen(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    ),
                  ),
                  _actionButton(
                    context,
                    "Receive Money",
                    Icons.qr_code_scanner,
                    Colors.green,
                    () => PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: ReceiveMoneyScreen(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    ),
                  ),
                  _actionButton(
                    context,
                    "Profile",
                    Icons.person,
                    Colors.purple,
                    () => PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: ProfileScreen(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Recent Transactions
              const Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              RecentTranscation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
