import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/utils/send_money_reciever_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class SendMoneyScreen extends StatefulWidget {
  final String? scannedWalletId;

  const SendMoneyScreen({Key? key, this.scannedWalletId}) : super(key: key);

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  late TextEditingController receiverController;

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
        title: const Text("Send Money",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Balance Card
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: isDarkMode ? Colors.grey[850] : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_balance_wallet,
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                value.showbalance
                                    ? Text(
                                        "NPR\$${value.balance.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                      )
                                    : Text(
                                        "\NPR****",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                Text("Balance",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                              ],
                            ),
                          ],
                        ),
                        //hide or show balance icon

                        value.showbalance
                            ? IconButton(
                                onPressed: () {
                                  value.toogleShowBalance();
                                },
                                icon: Icon(Icons.visibility,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              )
                            : IconButton(
                                onPressed: () {
                                  value.toogleShowBalance();
                                },
                                icon: Icon(Icons.visibility_off,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Recent Fund Transfer List (Horizontal ListView)
                Card(
                  color: isDarkMode ? Colors.grey[850] : Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    // decoration: BoxDecoration(
                    //   color: isDarkMode ? Colors.blueGrey[850] : Colors.blue[50],
                    //   borderRadius: BorderRadius.circular(10),
                    //   boxShadow: [
                    //     BoxShadow(
                    //         color: Colors.black.withOpacity(0.1),
                    //         blurRadius: 8,
                    //         offset: Offset(0, 4)),
                    //   ],
                    // ),
                    child: SizedBox(
                      height:
                          70, // Set fixed height for the horizontal list view
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(5, (index) {
                          return Card(
                            margin: const EdgeInsets.only(right: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name $index",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  Text(
                                      "Balance: \$${(100 + index * 20).toStringAsFixed(2)}",
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Card(
                  color: isDarkMode ? Colors.grey[850] : Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        // Receiver Wallet ID Input
                        TextField(
                          controller: receiverController,
                          decoration: InputDecoration(
                            labelText: "Receiver Wallet ID",
                            labelStyle: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black87),
                            prefixIcon: Icon(
                              Icons.account_balance_wallet,
                              color: Colors.blueAccent,
                              size: 30,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor:
                                isDarkMode ? Colors.grey[800] : Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Proceed Button
                        GestureDetector(
                          onTap: () {
                            if (receiverController.text.isNotEmpty) {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: SendMoneyRecieverDetailScreen(
                                  receiverId: receiverController.text,
                                ),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please enter valid details")));
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: Offset(0, 4)),
                              ],
                            ),
                            child: Text("Proceed",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                Card(
                  color: isDarkMode ? Colors.grey[850] : Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    //write somethings about transcation are secured type of stuff
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
