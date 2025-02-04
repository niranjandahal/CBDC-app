import 'package:cbdc/screens/transcations/transcatondetail.dart';
import 'package:cbdc/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbdc/provider/userprovider.dart';

class RecentTranscation extends StatefulWidget {
  const RecentTranscation({super.key});

  @override
  State<RecentTranscation> createState() => _RecentTranscationState();
}

class _RecentTranscationState extends State<RecentTranscation> {
  @override
  void initState() {
    super.initState();

    print("init state called");

    // Fetch transactions only once when the widget initializes
    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final transactions = userProvider.transactions;
        final isLoading = userProvider.isrecenttranscationloading;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (transactions.isEmpty) {
          return const Center(child: Text("No transactions found."));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TransactionDetail(transaction: transaction),
                  ),
                );
              },
              child: TransactionCard(
                title: transaction['receiver']['name'],
                subtitle: transaction['status'],
                amount: "-\Rs ${transaction['amount']}",
                isCredit: transaction['isCredit'],
              ),
            );

            // return TransactionCard(
            //   title: "${transaction['receiver']['name']}",
            //   subtitle: transaction['status'],
            //   amount: "-\Rs ${transaction['amount']}",
            //   isCredit: transaction['isCredit'],
            // );
          },
        );
      },
    );
  }
}
