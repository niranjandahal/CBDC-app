import 'package:flutter/material.dart';
import "package:cbdc/services/user_info.dart";

class BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Current Balance",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: "NPR ", // Smaller "NPR"
              style: TextStyle(
                color: Colors.white,
                fontSize: 18, // Smaller font size for "NPR"
                fontWeight: FontWeight.normal,
                letterSpacing: 1,
              ),
              children: [
                TextSpan(
                  text:
                      "${UserInfo.balance.toStringAsFixed(2)}", // Larger amount
                  style: TextStyle(
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
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
