import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

class ReceiveMoneyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get current theme

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
            Text(
              "Your Wallet QR Code",
              style: theme.textTheme.titleLarge, // Adapt text color
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Share this QR code with others to receive payments.",
              style: theme.textTheme.bodyMedium, // Adapt text color
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Ensure QR code is visible
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: QrImageView(
                  data: "user_wallet_id_123456",
                  version: QrVersions.auto,
                  size: 250,
                  foregroundColor: Colors.black, // Ensure QR code is visible
                  backgroundColor: Colors.white, // Force white background
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Wallet ID: user_wallet_id_123456",
              style: theme.textTheme.bodyMedium, // Adapt text color
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                    ClipboardData(text: "user_wallet_id_123456"));

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
