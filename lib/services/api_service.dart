import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_info.dart';
import 'package:cbdc/models/transaction.dart';

class ApiService {
  static const String baseUrl =
      "http://backend.url/api"; // Replace with backend URL

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

