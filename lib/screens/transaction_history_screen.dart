import 'package:flutter/material.dart';
import '../widgets/transaction_card.dart'; // Import the reusable widget

class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: 10, // Hardcoded for now
        itemBuilder: (context, index) {
          return TransactionCard(
            title: "User ${index + 1}",
            subtitle: "Completed",
            amount: "-\RS ${(index + 1) * 50}",
            isCredit: index % 2 == 0,
          );
        },
      ),
    );
  }
}
