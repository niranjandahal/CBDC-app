import 'dart:convert';
import 'package:cbdc/screens/auth/login_screen.dart';
import 'package:cbdc/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';

class UserProvider with ChangeNotifier {
  static const String baseUrl = "http://192.168.10.77:5000/api/v1";
  // static const String baseUrl = "https://cbdc-backend.vercel.app/api/v1";

  // Timer? _balanceTimer;

  List _transactions = [];
  bool isrecenttranscationloading = false;

  String _walletuserid = "";
  String _fullName = "";
  String _email = "";
  double _balance = -1;
  String _userImageurl = "";
  String _governmentIdImageUrl = "";
  String _dob = "";
  String _citizenidno = "";

  bool _isTransactionInProgress = false;

  bool get isTransactionInProgress => _isTransactionInProgress;

  //kyc
  String _kycStatus = "Pending"; // You can set default as "Pending"

  // 👀 Getters 👀

  String get walletuserid => _walletuserid;
  String get fullName => _fullName;
  String get email => _email;
  double get balance => _balance;
  List<dynamic> get transactions => _transactions;

  String get userImageurl => _userImageurl;
  String get governmentIdImageUrl => _governmentIdImageUrl;
  String get dob => _dob;
  String get citizenidno => _citizenidno;
  String get baseurl => baseUrl;

  //kyc

  String get kycStatus => _kycStatus;

  // 👀  Save Wallet ID to SharedPreferences 👀

  Future<void> _savewalletuserid(String walletuserid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("wallet_id", walletuserid);
  }

  // 👀 Check if User is Logged In 👀

  Future<bool> checkLoginState() async {
    if (_walletuserid.isNotEmpty) return true;

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
      print(
          "User registered successfully and here is the response data!!!! ............{{{{{}}}}}}}]]]]]]] data :::::::"
          "$responseData");
      _setDataOfUseronLoginAndSignUp(responseData["user"]);
      await _savewalletuserid(_walletuserid);
      notifyListeners();

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

    print("waiting for reponse body");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("User Logged IN successfully: $responseData");

      // Wait for data storage to complete
      _setDataOfUseronLoginAndSignUp(responseData["user"]);
      await _savewalletuserid(_walletuserid);

      print("Checking for wallet id: $_walletuserid");

      notifyListeners();

      // Now navigate to MainNavigation
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: MainNavigation(),
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } else {
      String errorMessage =
          jsonDecode(response.body)["message"] ?? "Login failed";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

//👀 Function to set transaction PIN 👀
  Future<void> setTransactionPin(
      BuildContext context, String transactionPin) async {
    if (_walletuserid.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/user/setpin"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "transactionPin": transactionPin,
          "userId": _walletuserid,
        }),
      );

      print("Set PIN API Response: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transaction PIN set successfully!")),
        );
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: MainNavigation(),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      } else {
        print("Failed to set PIN: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error: ${jsonDecode(response.body)['message']}")),
        );
      }
    } catch (e) {
      print("Exception while setting PIN: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error. Please try again.")),
      );
    }
  }

  // 👀 Fetch User Details 👀
  Future<void> fetchUserInfo() async {
    if (_walletuserid.isEmpty) return;

    print("fetch user infor $_walletuserid");

    try {
      print(" try fetch user infor $_walletuserid");

      final response = await http.get(
        Uri.parse("$baseUrl/user/showme/$_walletuserid"), // UserID in URL
        headers: {
          "Content-Type": "application/json",
        },
      );
      print("fetch user infor $_walletuserid");

      print("fetch user function Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("User details fetched successfully: $data");
        _setDataOfUseronLoginAndSignUp(data["user"]);
        notifyListeners();
      } else {
        print("Failed to fetch user info. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to fetch user info");
      }
    } catch (error) {
      print("Error fetching user info: $error");
    }
  }

  // 👀 Fetch Transactions 👀

  Future<void> fetchTransactions() async {
    if (_walletuserid.isEmpty) return;

    isrecenttranscationloading = true; // Start loading
    notifyListeners();

    print("fetch transc aclled");

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/transactions/$_walletuserid"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print("fetchTransaction response incoming:");

        List<dynamic> transactions = jsonDecode(response.body)['transactions'];

        _transactions = transactions.map((transaction) {
          bool isCredit = transaction['sender']['_id'] == _walletuserid;
          return {
            ...transaction,
            'isCredit': isCredit,
          };
        }).toList();
      } else {
        _transactions = [];
        print("Failed to fetch transactions. Response: ${response.body}");
      }
    } catch (e) {
      _transactions = [];
      print("Error fetching transactions: $e");
    }

    isrecenttranscationloading = false; // Stop loading
    notifyListeners();
  }

  // 👀 Fetch individual transcations 👀
  Future<void> fetchindvidualTransactions() async {
    if (_walletuserid.isEmpty) return;

    final response = await http.get(
      Uri.parse("$baseUrl/transactions/$_walletuserid"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      _transactions = jsonDecode(response.body)['transactions'];
      print(
          "User transcation successfully and here is the response data!!!! ............{{{{{}}}}}}}]]]]]]] data :::::::"
          "$_transactions");
      notifyListeners();
    } else {
      throw Exception("Failed to fetch transactions");
    }
  }

  void _setDataOfUseronLoginAndSignUp(Map<String, dynamic> data) {
    // Update only if the values are not already set

    if (_walletuserid.isEmpty) {
      _walletuserid = data['_id'] ?? "";
    }

    if (_fullName.isEmpty) {
      _fullName = data['name'] ?? "";
    }

    if (_balance == -1) {
      // Assuming -1 is an invalid balance
      _balance = (data['balance'] ?? 0).toDouble();
    }

    if (_email.isEmpty) {
      _email = data['email'] ?? "";
    }

    _kycStatus = data['kycStatus'] ?? "Pending";
    _dob = data['dateOfBirth'] ?? "";
    _citizenidno = data['governmentIdNumber'] ?? "";

    // Debugging prints
    print("Updated User Info:");
    print("Full Name: $_fullName");
    print("Wallet User ID: $_walletuserid");
    print("Balance: $_balance");
    print("Email: $_email");
    // print("kycstatus": _kycStatus);

    notifyListeners();
  }

  Future<void> sendMoney(BuildContext context, String receiverId, double amount,
      String pin) async {
    print(pin);
    if (_walletuserid.isEmpty) return;

    if (_isTransactionInProgress) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("A transaction is already in progress")),
      );
      return;
    }

    _isTransactionInProgress = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/transactions/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "senderId": _walletuserid,
          "receiverId": receiverId,
          "amount": amount,
          "transactionPin": pin,
          "transactionType": "transfer",
          "description": "Money transfer",
        }),
      );

      print(response.body);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _balance = (data['user']['balance'] ?? -1).toDouble();
        notifyListeners();

        // Navigate first, then show success message
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainNavigation()),
            (route) => false,
          );

          // Show success message after navigation
          Future.microtask(() {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Transaction Successful")),
            );
          });
        }
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? "Transaction failed";
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      _isTransactionInProgress = false;
      notifyListeners();
    }
  }

  //👀 get balance 👀

  Future<void> getBalance() async {
    print("get balance called");

    if (_walletuserid.isEmpty) return;

    final url = Uri.parse("$baseUrl/user/getbalance/$_walletuserid");

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("User balance fetched successfully: $data");

      _balance = (data['balance'] ?? 0).toDouble();
      notifyListeners();
    } else {
      print("Failed to fetch user balance: ${response.body}");
      throw Exception("Failed to fetch user balance");
    }
  }

  //👀 submit KYC 👀
  Future<void> submitKYC(
    BuildContext context,
    String dob,
    String idNumber,
    XFile profileImage,
    XFile idCardImage,
  ) async {
    if (_walletuserid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in!")),
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/images/complete-registration/$_walletuserid"),
      );

      request.fields['dateOfBirth'] = dob;
      request.fields['governmentIdNumber'] = idNumber;

      // Add files with explicit content type
      request.files.add(
        await http.MultipartFile.fromPath(
          'profilePhoto',
          profileImage.path,
          contentType: MediaType('image', 'jpeg'), // Adjust based on file type
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'governmentIdImage',
          idCardImage.path,
          contentType: MediaType('image', 'jpeg'), // Adjust based on file type
        ),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("KYC Submitted Successfully! ✅")),
        );
        _kycStatus = "Submitted";
        notifyListeners();
      } else {
        String errorMessage =
            jsonDecode(responseBody)['message'] ?? "KYC submission failed";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting KYC: $e")),
      );
    }
  }

//   //👀 Function to Fetch KYC Details 👀

  // Future<void> getKYCDetails() async {
  //   if (_walletuserid.isEmpty) return;

  //   try {
  //     final response = await http.get(
  //       Uri.parse("$baseUrl/images/profile/$_walletuserid"),
  //       headers: {"Content-Type": "application/json"},
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       _kycDetails = data['kycDetails'];
  //       _kycStatus = data['kycStatus'] ?? "Pending";
  //       notifyListeners();
  //     } else {
  //       print("Failed to fetch KYC details: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("Error fetching KYC details: $e");
  //   }
  // }
// // Start the periodic balance update
// void startPeriodicBalanceUpdate() {
//   _balanceTimer = Timer.periodic(Duration(minutes: 2), (timer) {
//     getBalance(); // Refresh balance every minute
//     fetchTransactions(); // Refresh transactions every minute
//   });
// }

// // Stop the periodic balance update
// void stopPeriodicBalanceUpdate() {
//   _balanceTimer?.cancel();
// }

// @override
// void dispose() {
//   stopPeriodicBalanceUpdate(); // Cancel timer when no longer needed
//   super.dispose();
// }

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
