import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/utils/send_money_remarks_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMoneyRecieverDetailScreen extends StatefulWidget {
  final String receiverId;

  const SendMoneyRecieverDetailScreen({
    Key? key,
    required this.receiverId,
  }) : super(key: key);

  @override
  _SendMoneyRecieverDetailScreenState createState() =>
      _SendMoneyRecieverDetailScreenState();
}

class _SendMoneyRecieverDetailScreenState
    extends State<SendMoneyRecieverDetailScreen> {
  late TextEditingController amountController;
  String enteredAmount = "";
  // Function to add digits to the entered amount
  void addDigit(String digit) {
    setState(() {
      enteredAmount += digit;
      amountController.text = enteredAmount; // Update the text field
    });
  }

// Function to remove the last digit
  void removeLastDigit() {
    setState(() {
      if (enteredAmount.isNotEmpty) {
        enteredAmount = enteredAmount.substring(0, enteredAmount.length - 1);
        amountController.text = enteredAmount; // Update the text field
      }
    });
  }

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Confirm Transaction",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Card (Same as previous page)
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
                const SizedBox(height: 10),

                // Recent Fund Transfer List (Horizontal ListView)
                Card(
                  color: isDarkMode ? Colors.grey[850] : Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        //reciever name

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(
                            //   "To: ${value.getname(widget.receiverId)}",
                            //   style: TextStyle(
                            //       fontSize: 18,
                            //       fontWeight: FontWeight.bold,
                            //       color:
                            //           isDarkMode ? Colors.white : Colors.black),
                            // ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.edit,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                            ),
                          ],
                        ),

                        //reciever id
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ID: ${widget.receiverId}",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.edit,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                            ),
                          ],
                        ),
                      ],
                      // Set fixed height for the horizontal list view
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Amount Card (with custom number buttons)
                Container(
                  // height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: isDarkMode ? Colors.grey[850] : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height *
                                    0.42, // Fix height properly
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    // Amount Display Field

                                    Row(
                                      //amount text with _________ field for amount
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Amount",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //___________ underline type of textfield with amount controller
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5, // Constraining the width to 80% of the screen width
                                              child: TextField(
                                                controller: amountController,
                                                readOnly: true,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),

                                    // TextField(
                                    //   controller: amountController,
                                    //   readOnly: true,
                                    //   textAlign: TextAlign.center,
                                    //   style: TextStyle(
                                    //       fontSize: 24,
                                    //       fontWeight: FontWeight.bold),
                                    //   decoration: InputDecoration(
                                    //     border: OutlineInputBorder(
                                    //         borderRadius:
                                    //             BorderRadius.circular(8)),
                                    //     filled: true,
                                    //     fillColor: isDarkMode
                                    //         ? Colors.grey[800]
                                    //         : Colors.white,
                                    //   ),
                                    // ),
                                    const SizedBox(height: 10),

                                    // Dialpad using Column & Rows instead of GridView
                                    Column(
                                      children: [
                                        for (var row in [
                                          ['1', '2', '3'],
                                          ['4', '5', '6'],
                                          ['7', '8', '9'],
                                          ['.', '0', 'X']
                                        ])
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: row.map((label) {
                                              return GestureDetector(
                                                onTap: () {
                                                  if (label == "X") {
                                                    removeLastDigit();
                                                  } else {
                                                    addDigit(label);
                                                  }
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2, // Adjusted size
                                                  height: 50, // Fixed height
                                                  margin: EdgeInsets.all(
                                                      4), // Adjusted spacing
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: label == "X"
                                                        ? Colors.redAccent
                                                        : Colors.blueAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // Soft corners
                                                  ),
                                                  child: label == "X"
                                                      ? Icon(Icons.backspace,
                                                          color: Colors.white,
                                                          size: 22)
                                                      : Text(label,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 22)),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Continue Button
                Container(
                  // color: Colors.red,
                  child: GestureDetector(
                    onTap: () {
                      if (enteredAmount.isNotEmpty) {
                        // Proceed to next page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => sendmoneyremarksscreen(
                              receiverId: widget.receiverId,
                              amount: double.tryParse(enteredAmount) ?? 0.0,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please enter amount")));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Continue",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
