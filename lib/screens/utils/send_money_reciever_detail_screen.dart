import 'package:cbdc/screens/utils/send_money_remarks_screen.dart';
import 'package:cbdc/widgets/custom_dial_pad.dart';
import 'package:cbdc/widgets/showorhidebalancecard.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

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
  TextEditingController amountController = TextEditingController();
  // String enteredAmount = "";
  // Function to add digits to the entered amount
  void addDigit(String digit) {
    setState(() {
      String currentText = amountController.text;

      if (digit == '0' || digit == '.') {
        if (currentText.isEmpty) {
          // Don't allow 0 if no digit yet
          return;
        }
      }

      if (currentText.contains('.')) {
        // Only allow one dot
        return;
      }

      amountController.text = currentText + digit;
    });
  }

// Function to remove the last digit
  void removeLastDigit() {
    setState(() {
      String currentText = amountController.text;
      if (currentText.isNotEmpty) {
        amountController.text =
            currentText.substring(0, currentText.length - 1);
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
    bool isFieldNotEmpty = amountController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Send Money",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Color(0xFF121212) : Colors.blueAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Card (Same as previous page)
                ShowOrHideBalanceCard(),
                const SizedBox(height: 10),

                Card(
                  color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        //reciever name

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("first name ***",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ))
                          ],
                        ),

                        //reciever id
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              // Prevents overflow
                              child: Text(
                                "Wallet ID: ${widget.receiverId}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode
                                        ? Color(0xFFE0E0E0)
                                        : Colors.black),
                                overflow: TextOverflow
                                    .ellipsis, // Adds "..." if text is too long
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                PersistentNavBarNavigator.pop(context);
                                // Navigator.pop(context);
                              },
                              icon: Icon(Icons.edit,
                                  color: isDarkMode
                                      ? Color(0xFFE0E0E0)
                                      : Colors.black),
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
                // Container(
                //   // height: MediaQuery.of(context).size.height * 0.6,
                //   child: Column(
                //     children: [
                //       Card(
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //         color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                //         child: Padding(
                //           padding: const EdgeInsets.all(6.0),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Container(
                //                 height: MediaQuery.of(context).size.height *
                //                     0.42, // Fix height properly
                //                 padding: const EdgeInsets.all(10),
                //                 child: Column(
                //                   children: [
                //                     // Amount Display Field

                //                     Row(
                //                       //amount text with _________ field for amount
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.spaceBetween,
                //                       children: [
                //                         Text(
                //                           "Send Amount       Rs",
                //                           style: TextStyle(
                //                               fontSize: 16,
                //                               // fontWeight: FontWeight.bold,
                //                               color: isDarkMode
                //                                   ? Color(0xFFE0E0E0)
                //                                   : Colors.black),
                //                         ),
                //                         Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.start,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.start,
                //                           children: [
                //                             Container(
                //                               width: MediaQuery.of(context)
                //                                       .size
                //                                       .width *
                //                                   0.4,
                //                               child: TextField(
                //                                 controller: amountController,
                //                                 readOnly: true,
                //                                 textAlign: TextAlign.right,
                //                                 style: TextStyle(
                //                                     fontSize: 24,
                //                                     fontWeight: FontWeight.bold),
                //                                 decoration: InputDecoration(
                //                                   hintText: "00.00",
                //                                   hintStyle: TextStyle(
                //                                       color: Colors.grey),
                //                                   isDense:
                //                                       true, // reduce vertical padding
                //                                   contentPadding:
                //                                       EdgeInsets.symmetric(
                //                                           vertical: 8),
                //                                   enabledBorder:
                //                                       UnderlineInputBorder(
                //                                     borderSide: BorderSide(
                //                                         color: isFieldNotEmpty
                //                                             ? Colors.green
                //                                             : Colors.grey,
                //                                         width: 2),
                //                                   ),
                //                                   focusedBorder:
                //                                       UnderlineInputBorder(
                //                                     borderSide: BorderSide(
                //                                         color: isFieldNotEmpty
                //                                             ? Colors.green
                //                                             : Colors.grey,
                //                                         width: 2),
                //                                   ),
                //                                 ),
                //                               ),
                //                             )
                //                           ],
                //                         ),
                //                       ],
                //                     ),

                //                     const SizedBox(height: 10),

                CustomDialPad(
                  onDigitPressed: addDigit,
                  onBackspacePressed: removeLastDigit,
                  amountController: amountController,
                  isFieldNotEmpty: isFieldNotEmpty,
                  isDarkMode: isDarkMode,
                ),

                // Dialpad using Column & Rows instead of GridView
                // Column(
                //   children: [
                //     for (var row in [
                //       ['1', '2', '3'],
                //       ['4', '5', '6'],
                //       ['7', '8', '9'],
                //       ['.', '0', 'X']
                //     ])
                //       Row(
                //         mainAxisAlignment:
                //             MainAxisAlignment.spaceEvenly,
                //         children: row.map((label) {
                //           return GestureDetector(
                //             onTap: () {
                //               if (label == "X") {
                //                 removeLastDigit();
                //               } else {
                //                 addDigit(label);
                //               }
                //             },
                //             child: Container(
                //               width: MediaQuery.of(context)
                //                       .size
                //                       .width *
                //                   0.2, // Adjusted size
                //               height: 50, // Fixed height
                //               margin: EdgeInsets.all(
                //                   4), // Adjusted spacing
                //               alignment: Alignment.center,
                //               decoration: BoxDecoration(
                //                 color: label == "X"
                //                     ? Colors.redAccent
                //                     : Color.fromARGB(
                //                         255, 79, 170, 245),
                //                 borderRadius:
                //                     BorderRadius.circular(
                //                         8), // Soft corners
                //               ),
                //               child: label == "X"
                //                   ? Icon(Icons.backspace,
                //                       color: Colors.white,
                //                       size: 22)
                //                   : Text(label,
                //                       style: TextStyle(
                //                           color: Colors.white,
                //                           fontSize: 22)),
                //             ),
                //           );
                //         }).toList(),
                //       ),
                //   ],
                // ),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 10),

                // Continue Button
                Container(
                  // color: Colors.red,
                  child: GestureDetector(
                    onTap: () {
                      if (amountController.text.isNotEmpty) {
                        // Proceed to next page
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: sendmoneyremarksscreen(
                            receiverId: widget.receiverId,
                            amount:
                                double.tryParse(amountController.text) ?? 0.0,
                          ),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
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
                        color: Color.fromARGB(255, 68, 158, 231),
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
