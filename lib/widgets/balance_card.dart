import 'package:cbdc/provider/userprovider.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:cbdc/provider/theme_provider.dart';

class BalanceCard extends StatefulWidget {
  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  // @override
  // void initState() {
  //   super.initState();
  //   // Provider.of<UserProvider>(context, listen: false).getBalance();
  //   // Start the periodic balance update when the widget is created
  //   Provider.of<UserProvider>(context, listen: false)
  //       .startPeriodicBalanceUpdate();
  // }

  // @override
  // void dispose() {
  //   // Stop the periodic balance update when the widget is disposed
  //   Provider.of<UserProvider>(context, listen: false)
  //       .stopPeriodicBalanceUpdate();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // 👀 Move inside build
    final isDarkMode = themeProvider.isDarkMode;

    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      Colors.grey[900]!,
                      Colors.black
                    ] // 👀 Fixing gradient colors
                  : [Colors.blue, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Current Balance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "NPR ", // Smaller "NPR"
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Smaller font size for "NPR"
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1,
                  ),
                  children: [
                    TextSpan(
                      text: value.balance.toStringAsFixed(2), // Larger amount
                      style: const TextStyle(
                        fontSize: 36, // Larger font size for the amount
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Last updated: Just now",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
