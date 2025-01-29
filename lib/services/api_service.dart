import 'dart:convert';
import 'package:cbdc/screens/main_navigation.dart';
import 'package:http/http.dart' as http;
import 'user_info.dart';
import 'package:cbdc/models/transaction.dart';
import 'package:flutter/material.dart';

class ApiService {
  static const String baseUrl = "https://cbdc-backend.vercel.app/api/v1";

  static Future<void> registerUser(BuildContext context, String fullName,
      String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/user/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": fullName,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 201) {
      // ✅ Navigate to MainNavigation on successful registration
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigation(),
          ));
    } else {
      // ❌ Show error message if registration fails
      final responseData = jsonDecode(response.body);
      String errorMessage = responseData["message"] ?? "Registration failed";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  //login user
  static Future<void> loginUser(
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
      String walletId = responseData["walletId"];
      UserInfo.walletId = walletId;
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigation(),
          ));
    } else {
      final responseData = jsonDecode(response.body);
      String errorMessage = responseData["message"] ?? "Login failed";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  static Future<void> fetchUserInfo(String walletId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/user/details"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"walletId": walletId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      UserInfo.walletId = walletId;
      UserInfo.balance = data['balance'];
      UserInfo.fullName = data['fullName'];
      UserInfo.profilePic = data['profilePic'];
      UserInfo.email = data['email'];
      UserInfo.phone = data['phone'];
    } else {
      throw Exception("Failed to fetch user info");
    }
  }

  static Future<void> sendMoney(
      String senderId, String receiverId, double amount) async {
    final response = await http.post(
      Uri.parse("$baseUrl/transaction/send"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "senderWalletId": senderId,
        "receiverWalletId": receiverId,
        "amount": amount,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Transaction failed");
    }
  }

  static Future<List<Transaction>> fetchTransactions(String walletId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/transaction/history"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"walletId": walletId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      UserInfo.transactions = data['transactions'];
    } else {
      throw Exception("Failed to fetch transactions");
    }
    return [];
  }
}
