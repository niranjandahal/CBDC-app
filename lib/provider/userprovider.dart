import 'dart:convert';
import 'package:cbdc/screens/login_screen.dart';
import 'package:cbdc/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class UserProvider with ChangeNotifier {
  static const String baseUrl = "https://cbdc-backend.vercel.app/api/v1";

  String _walletuserid = "";
  String _fullName = "";
  String _email = "";
  double _balance = -1;

  List<dynamic> _transactions = [];

  // 👀 Getters 👀

  String get walletuserid => _walletuserid;
  String get fullName => _fullName;
  String get email => _email;
  double get balance => _balance;
  List<dynamic> get transactions => _transactions;

  // 👀  Save Wallet ID to SharedPreferences 👀

  Future<void> _savewalletuserid(String walletuserid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("wallet_id", walletuserid);
  }

  // 👀 Check if User is Logged In 👀

  Future<bool> checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    _walletuserid = prefs.getString("wallet_id") ?? "";
    notifyListeners();
    return _walletuserid.isNotEmpty;
  }

  // 👀 Register User & update Data 👀

  Future<void> registerUser(
      BuildContext context, String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/user/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 201) {
      print(responseData);
      _setDataOfUseronLoginAndSignUp(responseData["user"]);
      _savewalletuserid(_walletuserid);
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: MainNavigation(),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } else {
      String errorMessage = responseData["message"] ?? "Registration failed";
      print(errorMessage);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  // 👀 Login User & update Data 👀

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/user/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      _setDataOfUseronLoginAndSignUp(responseData["user"]);
      print(responseData);
      _savewalletuserid(_walletuserid);
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: MainNavigation(),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } else {
      String errorMessage =
          jsonDecode(response.body)["message"] ?? "Login failed";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  // 👀 Fetch User Details 👀

  Future<void> fetchUserInfo() async {
    if (_walletuserid.isEmpty) return;

    if (_fullName.isEmpty || _balance == -1 || _email.isEmpty) {
      final response = await http.post(
        Uri.parse("$baseUrl/user/details"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"walletuserid": _walletuserid}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _setDataOfUseronLoginAndSignUp(data);
      } else {
        throw Exception("Failed to fetch user info");
      }
    } else {
      return;
    }
  }

  // 👀 Fetch Transactions 👀

  Future<void> fetchTransactions() async {
    if (_walletuserid.isEmpty) return;

    final response = await http.post(
      Uri.parse("$baseUrl/transaction/history"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"walletuserid": _walletuserid}),
    );

    if (response.statusCode == 200) {
      _transactions = jsonDecode(response.body)['transactions'];
      notifyListeners();
    } else {
      throw Exception("Failed to fetch transactions");
    }
  }

  void _setDataOfUseronLoginAndSignUp(Map<String, dynamic> data) {
    _fullName = data['name'] ?? "";
    _walletuserid = data['userId'] ?? "";
    _balance = (data['balance'] ?? 0).toDouble();
    _email = data['email'] ?? "";
    notifyListeners();
  }

  // 👀 Send Money 👀

  Future<void> sendMoney(
      BuildContext context, String receiverId, double amount) async {
    if (_walletuserid.isEmpty) return;

    final String apiUrl = "$baseUrl/transactions"; // Updated API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_JWT_TOKEN", // Replace with actual token
        },
        body: jsonEncode({
          "receiverId": receiverId,
          "amount": amount,
          "transactionType": "transfer",
          "description": "Money transfer",
        }),
      );

      print("debuggginhg send money");

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        print(data);
        // Assuming response contains updated balance
        _balance = (data['balance'] ?? 0).toDouble();
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transaction Successful")),
        );

        // Navigate back to home or transaction history screen
        Navigator.pop(context);
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? "Transaction failed";
        print(errorMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  //👀 get balance 👀

  Future<void> getBalance() async {
    if (_walletuserid.isEmpty) return;

    final response = await http.post(
      Uri.parse("$baseUrl/user/balance"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"walletuserid": _walletuserid}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _balance = (data['balance'] ?? 0).toDouble();
      notifyListeners();
    } else {
      throw Exception("Failed to fetch user info");
    }
  }

  // 👀 Logout User 👀

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("wallet_id");

    _walletuserid = "";
    _fullName = "";
    _email = "";
    _balance = -1;
    _transactions = [];

    notifyListeners();
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: LoginScreen(),
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }
}
