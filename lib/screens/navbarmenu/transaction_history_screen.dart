import 'package:cbdc/screens/transcations/recenttranscation.dart';
import 'package:flutter/material.dart';
// import '../../widgets/transaction_card.dart'; // Import the reusable widget

class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Transaction History"),
        ),
        body: RecentTranscation());
  }
}
