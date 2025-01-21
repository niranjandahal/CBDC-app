import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

class ReceiveMoneyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receive Money"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Your Wallet QR Code",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Share this QR code with others to receive payments.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Center(
              child: // Add QrImage widget here
                  Container(
                height: 300,
                width: MediaQuery.of(context).size.width * 0.8,
                child: QrImageView(
                  data: "user_wallet_id_123456",
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Wallet ID: user_wallet_id_123456",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: "your text"));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Wallet ID copied to clipboard!")),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text("Copy Wallet ID"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
