import 'package:flutter/material.dart';
import 'package:cbdc/services/api_service.dart';
import 'package:cbdc/services/user_info.dart';

class SendMoneyScreen extends StatelessWidget {
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Money"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: receiverController,
              decoration: InputDecoration(labelText: "Receiver Wallet ID"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final receiverId = receiverController.text;
                final amount = double.tryParse(amountController.text) ?? 0;

                await ApiService.sendMoney(
                    UserInfo.walletId, receiverId, amount);
                await ApiService.fetchUserInfo(
                    UserInfo.walletId); // Update balance

                Navigator.pop(context); // Return to previous screen
              },
              child: Text("Send Money"),
            ),
          ],
        ),
      ),
    );
  }
}
