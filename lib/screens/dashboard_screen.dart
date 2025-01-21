import 'package:cbdc/themes/theme_provider.dart';
import 'package:cbdc/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import '../widgets/balance_card.dart'; // Import the reusable widget
import 'send_money_screen.dart';
import 'receive_money_screen.dart';
import 'profile_screen.dart';
import 'package:provider/provider.dart';

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
          // Notifications Icon
          // IconButton(
          //   icon: const Icon(Icons.notifications),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => NotificationsScreen()),
          //     );
          //   },
          // ),
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
              SizedBox(height: 30),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton(
                    context,
                    "Send Money",
                    Icons.send,
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendMoneyScreen(),
                      ),
                    ),
                  ),
                  _actionButton(
                    context,
                    "Receive Money",
                    Icons.qr_code_scanner,
                    Colors.green,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiveMoneyScreen(),
                      ),
                    ),
                  ),
                  _actionButton(
                    context,
                    "Profile",
                    Icons.person,
                    Colors.purple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Recent Transactions
              Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5, // Hardcoded for now
                itemBuilder: (context, index) {
                  return TransactionCard(
                    title: "Transfer to User ${index + 1}",
                    subtitle: "Successful",
                    amount: "-\Rs ${(index + 1) * 100}",
                    isCredit: false,
                  );
                },
              ),
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
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
