import 'package:cbdc/screens/auth/biometric_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import 'package:cbdc/provider/userprovider.dart';

class TransactionPin extends StatefulWidget {
  final String receiverId;
  final double amount;
  final String TranscationType;
  final String Remarks;

  TransactionPin(
      {super.key,
      required this.receiverId,
      required this.amount,
      required this.TranscationType,
      required this.Remarks});

  @override
  State<TransactionPin> createState() => _TransactionPinState();
}

class _TransactionPinState extends State<TransactionPin> {
  final TextEditingController _pinController = TextEditingController();
  bool _hasShownBiometricPopup = false;

  @override
  void initState() {
    super.initState();
    _initializeBiometric();
  }

  Future<void> _initializeBiometric() async {
    // Use UserProvider to get biometric status
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadBiometricPreference();
    await userProvider.loadtranscationpin();

    // Trigger biometric authentication if enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userProvider.isbiometricenabled && !_hasShownBiometricPopup) {
        _hasShownBiometricPopup = true;
        _authenticateAndSend(userProvider);
      }
    });
  }

  Future<void> _authenticateAndSend(UserProvider userProvider) async {
    await Biometricauth().handleBiometricAction(
      context: context,
      isForSetup: false, // Not enabling/disabling, just authenticating
      onSuccess: () {
        String? savedPin = userProvider.transactionPin;
        if (savedPin != null && savedPin.length == 4) {
          _sendWithPin(savedPin);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Saved PIN not found.")),
          );
        }
      },
      onFailure: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication cancelled")),
        );
      },
    );
  }

  void _sendWithPin(String pin) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.sendMoney(
      context,
      widget.receiverId,
      widget.amount,
      pin,
      widget.TranscationType,
      widget.Remarks,
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Enter Transaction PIN"),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter your 4-digit PIN",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Pinput(
              controller: _pinController,
              length: 4,
              obscureText: true,
              keyboardType: TextInputType.number,
              animationCurve: Curves.easeInOut,
              autofocus: true,
              defaultPinTheme: PinTheme(
                width: 50,
                height: 50,
                textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: userProvider.isTransactionInProgress
                    ? null
                    : () => _sendWithPin(_pinController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.blueAccent : Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: userProvider.isTransactionInProgress
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Confirm", style: TextStyle(fontSize: 16)),
              ),
            ),
            Selector<UserProvider, bool>(
              selector: (_, provider) => provider.isbiometricenabled,
              builder: (context, isEnabled, child) {
                if (!isEnabled) return SizedBox.shrink();
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        print("calling fingerprint");
                        final userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        await _authenticateAndSend(userProvider);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fingerprint,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Use Biometric Authentication",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            // if (_isBiometricEnabled) ...[
            //   const SizedBox(height: 10),
            //   GestureDetector(
            //     onTap: () async {
            //       print("calling fingerprint");
            //       await _authenticateAndSend(userProvider);
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Icon(
            //           Icons.fingerprint,
            //           color: isDarkMode ? Colors.white : Colors.black,
            //         ),
            //         const SizedBox(width: 10),
            //         Text(
            //           "Use Biometric Authentication",
            //           style: TextStyle(
            //             color: Colors.grey,
            //             fontStyle: FontStyle.italic,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
