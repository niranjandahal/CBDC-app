//remarks page for user screen
import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/transcations/transcationpinCheck.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class sendmoneyremarksscreen extends StatefulWidget {
  final String receiverId;
  final double amount;

  const sendmoneyremarksscreen({
    Key? key,
    required this.receiverId,
    required this.amount,
  }) : super(key: key);

  @override
  _sendmoneyremarksscreenState createState() => _sendmoneyremarksscreenState();
}

class _sendmoneyremarksscreenState extends State<sendmoneyremarksscreen> {
  List<String> purposes = ["Shopping", "Bills", "Food", "Others"];
  String selectedPurpose = "";
  TextEditingController remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaction Details",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: isDarkMode ? Colors.white : Colors.black),
                          const SizedBox(width: 10),
                          Column(
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
                                      "NPR****",
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
                      IconButton(
                        onPressed: () {
                          value.toogleShowBalance();
                        },
                        icon: Icon(
                            value.showbalance
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: isDarkMode ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Receiver Info Card
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "To: ${widget.receiverId}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                          ),
                          Text(
                            "ID: ${widget.receiverId}",
                            style: TextStyle(
                                fontSize: 16,
                                color:
                                    isDarkMode ? Colors.white70 : Colors.black),
                          ),
                        ],
                      ),
                      Text(
                        "NPR\$${widget.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.green : Colors.green),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Purpose Selection Grid
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Purpose",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: purposes.length,
                        itemBuilder: (context, index) {
                          String purpose = purposes[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPurpose = purpose;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selectedPurpose == purpose
                                    ? Colors.blueAccent
                                    : isDarkMode
                                        ? Colors.grey[800]
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedPurpose == purpose
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                ),
                              ),
                              child: Text(
                                purpose,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: selectedPurpose == purpose
                                      ? Colors.white
                                      : isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Remarks TextField
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Remarks",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: remarksController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter remarks (optional)",
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionPin(
                          receiverId: widget.receiverId,
                          amount: widget.amount,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Confirm",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
