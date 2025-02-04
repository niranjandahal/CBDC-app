import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/transcations/transcationpinCheck.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class SendMoneyScreen extends StatefulWidget {
  final String? scannedWalletId; // Accept scanned Wallet ID (optional)

  const SendMoneyScreen({Key? key, this.scannedWalletId}) : super(key: key);

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  late TextEditingController receiverController;
  final TextEditingController amountController = TextEditingController();
  String? selectedPurpose = "Food & Beverage"; // Default selected purpose
  final List<String> purposes = [
    "Food & Beverage",
    "Education",
    "Entertainment",
    "Health",
    "Others"
  ];

  @override
  void initState() {
    super.initState();
    receiverController =
        TextEditingController(text: widget.scannedWalletId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Money"),
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Card for balance display
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                color: isDarkMode ? Colors.grey[850] : Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Balance",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("\$${value.balance.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Receiver Wallet ID input
              TextField(
                controller: receiverController,
                decoration: InputDecoration(
                  labelText: "Receiver Wallet ID",
                  labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white38 : Colors.grey),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Amount input
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: "Amount",
                  labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white38 : Colors.grey),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Purpose dropdown menu
              DropdownButtonFormField<String>(
                value: selectedPurpose,
                items: purposes.map((String purpose) {
                  return DropdownMenuItem<String>(
                    value: purpose,
                    child: Text(purpose,
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPurpose = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Purpose",
                  labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white38 : Colors.grey),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Remarks input
              TextField(
                decoration: InputDecoration(
                  labelText: "Remarks (Optional)",
                  labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white38 : Colors.grey),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // Send Money button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  double amount = double.tryParse(amountController.text) ?? 0.0;

                  if (amount > 0 && receiverController.text.isNotEmpty) {
                    // Check if the receiver's wallet ID matches the user's wallet ID
                    if (receiverController.text == value.walletuserid) {
                      // Show error message if receiver is the same as the sender
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("You cannot send money to yourself!")),
                      );
                    } else {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: TransactionPin(
                            receiverId: receiverController.text,
                            amount: double.parse(amountController.text)),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );

                      // Proceed with sending money
                      // PersistentNavBarNavigator.pushNewScreen(
                      //   context,
                      //   screen: TranscationPin(),
                      //   withNavBar: false,
                      //   pageTransitionAnimation:
                      //       PageTransitionAnimation.cupertino,
                      // );
                      // Provider.of<UserProvider>(context, listen: false)
                      //     .sendMoney(context, receiverController.text, amount);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please enter valid details")),
                    );
                  }
                },
                child: const Text("Send Money", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
