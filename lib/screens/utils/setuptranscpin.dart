import 'package:cbdc/provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetupTransactionPin extends StatefulWidget {
  const SetupTransactionPin({super.key});

  @override
  State<SetupTransactionPin> createState() => _SetupTransactionPinState();
}

class _SetupTransactionPinState extends State<SetupTransactionPin> {
  final TextEditingController _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitPin() {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setTransactionPin(context, _pinController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Transaction PIN")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Enter 4-digit PIN",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "PIN cannot be empty";
                  }
                  if (value.length != 4) {
                    return "PIN must be 4 digits";
                  }
                  if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                    return "PIN must be numeric";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPin,
                child: const Text("Set PIN"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
