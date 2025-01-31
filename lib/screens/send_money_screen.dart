// import 'package:cbdc/provider/userprovider.dart';
// import 'package:cbdc/screens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class SendMoneyScreen extends StatelessWidget {
//   final TextEditingController receiverController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Send Money"),
//       ),
//       body: Consumer<UserProvider>(
//         builder: (context, value, child) => Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: receiverController,
//                 decoration:
//                     const InputDecoration(labelText: "Receiver Wallet ID"),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: amountController,
//                 decoration: const InputDecoration(labelText: "Amount"),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () async {
//                   value.sendMoney(context, receiverController.text,
//                       amountController.text as double);
//                 },
//                 child: const Text("Send Money"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cbdc/provider/userprovider.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    receiverController =
        TextEditingController(text: widget.scannedWalletId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send Money")),
      body: Consumer<UserProvider>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: receiverController,
                decoration:
                    const InputDecoration(labelText: "Receiver Wallet ID"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  double amount = double.tryParse(amountController.text) ?? 0.0;
                  if (amount > 0 && receiverController.text.isNotEmpty) {
                    Provider.of<UserProvider>(context, listen: false)
                        .sendMoney(context, receiverController.text, amount);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please enter valid details")),
                    );
                  }
                },
                child: const Text("Send Money"),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     double? amount = double.tryParse(amountController.text);
              //     if (amount == null || receiverController.text.isEmpty) {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(content: Text("Invalid input")),
              //       );
              //       return;
              //     }
              //     value.sendMoney(context, receiverController.text, amount);
              //   },
              //   child: const Text("Send Money"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
