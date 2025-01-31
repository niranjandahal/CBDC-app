import 'dart:convert';
import 'package:cbdc/screens/login_screen.dart';
import 'package:cbdc/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class UserProvider with ChangeNotifier {
  static const String baseUrl = "https://cbdc-backend.vercel.app/api/v1";

  String _walletId = "";
  String _fullName = "";
  String _userid = "";
  String _role = "";
  String _email = "";
  String _phone = "";
  String _profilePic = "";
  double _balance = 0.0;
  List<dynamic> _transactions = [];

  // ✅ Getters

  String get walletId => _walletId;
  String get fullName => _fullName;
  String get userid => _userid;
  String get role => _role;
  String get email => _email;
  String get phone => _phone;
  String get profilePic => _profilePic;
  double get balance => _balance;
  List<dynamic> get transactions => _transactions;

  // ✅ Check if User is Logged In
  Future<bool> checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    _walletId = prefs.getString("wallet_id") ?? "";
    notifyListeners();
    return _walletId.isNotEmpty;
  }

  // ✅ Register User & Save Data
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
      _updateOnLoginAndSignup(responseData["user"]);
      // _saveWalletId(_walletId);
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

  // ✅ Login User & Save Data
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
      _updateOnLoginAndSignup(responseData["user"]);
      print(responseData);
      // _saveWalletId(_walletId);
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

  // ✅ Fetch User Details
  Future<void> fetchUserInfo() async {
    if (_walletId.isEmpty) return;

    final response = await http.post(
      Uri.parse("$baseUrl/user/details"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"walletId": _walletId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _GetAllDataOfUser(data);
    } else {
      throw Exception("Failed to fetch user info");
    }
  }

  // ✅ Fetch Transactions
  Future<void> fetchTransactions() async {
    if (_walletId.isEmpty) return;

    final response = await http.post(
      Uri.parse("$baseUrl/transaction/history"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"walletId": _walletId}),
    );

    if (response.statusCode == 200) {
      _transactions = jsonDecode(response.body)['transactions'];
      notifyListeners();
    } else {
      throw Exception("Failed to fetch transactions");
    }
  }

  // ✅ Save Wallet ID to SharedPreferences
  Future<void> _saveWalletId(String walletId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("wallet_id", walletId);
  }

  // ✅ Update User Data Locally
  void _updateOnLoginAndSignup(Map<String, dynamic> data) {
    _fullName = data['name'] ?? "";
    _walletId = data['walletId'] ?? "";
    _userid = data['userId'] ?? "";
    _balance = (data['balance'] ?? 0).toDouble();
    notifyListeners();
  }

  // ✅ GetAllDataOfUser
  void _GetAllDataOfUser(Map<String, dynamic> data) {
    _fullName = data['name'] ?? "";
    _walletId = data['walletId'] ?? "";
    _userid = data['userId'] ?? "";
    _balance = (data['balance'] ?? 0).toDouble();
    notifyListeners();
  }

  // ✅ Logout User
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("wallet_id");

    _walletId = "";
    _fullName = "";
    _email = "";
    _phone = "";
    _profilePic = "";
    _balance = 0.0;
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
