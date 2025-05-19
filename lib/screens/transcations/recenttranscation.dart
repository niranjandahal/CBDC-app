import 'package:cbdc/screens/transcations/transcatondetail.dart';
import 'package:cbdc/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:cbdc/provider/userprovider.dart';

class RecentTranscation extends StatefulWidget {
  const RecentTranscation({super.key});

  @override
  State<RecentTranscation> createState() => _RecentTranscationState();
}

class _RecentTranscationState extends State<RecentTranscation> {
  //call fetch transaction method in init state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final transactions = userProvider.transactions;
        final isLoading = userProvider.isrecenttranscationloading;
        final currentWalletId = userProvider.walletuserid;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (transactions.isEmpty) {
          return const Center(child: Text("No transactions found."));
        }

        return ListView.builder(
          // shrinkWrap: true,
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];

            final senderId = transaction['senderId'];
            final receiverId = transaction['receiverId'];

            bool isSender = senderId == currentWalletId;
            bool isReceiver = receiverId == currentWalletId;

            // Defensive check
            if (!isSender && !isReceiver) {
              return const SizedBox(); // skip if not related to current user
            }

            final isCredit = isReceiver;
            final arrowIcon =
                isCredit ? Icons.arrow_downward : Icons.arrow_upward;
            final arrowColor = isCredit ? Colors.green : Colors.red;

            final otherPartyName = isCredit
                ? transaction['senderName']
                : transaction['receiverName'];

            final title = isCredit
                ? "fund received from $otherPartyName"
                : "fund transferred to $otherPartyName";

            final amountPrefix = isCredit ? "+" : "-";
            final amount = "$amountPrefix Rs ${transaction['amount']}";

            return GestureDetector(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: TransactionDetail(transaction: transaction),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: TransactionCard(
                title: title,
                subtitle: transaction['status'],
                amount: amount,
                isCredit: isCredit,
                arrowIcon: arrowIcon,
                arrowColor: arrowColor,
              ),
            );
          },
        );
      },
    );
  }
}
