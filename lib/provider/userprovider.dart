import 'dart:convert';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:cbdc/screens/auth/login_screen.dart';
import 'package:cbdc/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http_parser/http_parser.dart';

class UserProvider with ChangeNotifier {
  static const String baseUrl = "http://192.168.1.7:5000/api/v1";

  // static const String baseUrl = "http://192.168.1.3:5000/api/v1";
  // static const String baseUrl = "http://192.168.211.20:5000/api/v1";
  // static const String baseUrl = "https://cbdc-backend.vercel.app/api/v1";

//
//
//varaibles
//
//

  List _transactions = [];
  bool isrecenttranscationloading = false;
  bool showbalance = false;
  String _walletuserid = "";
  String _fullName = "";
  String _email = "";
  double _balance = 0.00;
  // String _userImageurl = "";
  // String _governmentIdImageUrl = "";
  String _dob = "";
  String _citizenidno = "";
  String _kycStatus = "Pending"; // You can set default as "Pending"

  // bool _isbiometricenabled = false;
  bool _isTransactionInProgress = false;
  String? _transactionPin;
  bool _isBiometricEnabled = false;
  bool _transactionpin_backend = false;
  bool get isTransactionInProgress => _isTransactionInProgress;
  String? get transactionPin => _transactionPin;
  bool get transactionpin_backend => _transactionpin_backend;

  //kyc
  // 👀 Getters 👀
  String get walletuserid => _walletuserid;
  String get fullName => _fullName;
  String get email => _email;
  double get balance => _balance;
  List<dynamic> get transactions => _transactions;
  // String get userImageurl => _userImageurl;
  // String get governmentIdImageUrl => _governmentIdImageUrl;
  String get dob => _dob;
  String get citizenidno => _citizenidno;
  String get baseurl => baseUrl;
  bool get isbiometricenabled => _isBiometricEnabled;
  //kyc
  String get kycStatus => _kycStatus;

  //
  // 👀 Three function for biometric for biometric auth.dart file 👀
  //

  Future<void> loadBiometricPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isBiometricEnabled = prefs.getBool('isbiometricenabled') ?? false;
    notifyListeners();
  }

  Future<void> setBiometricEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isbiometricenabled', value);
    _isBiometricEnabled = value;
    notifyListeners();
  }

//
//function for login screen
//
  Future<void> checkBiometricLoginAvailable() async {
    final prefs = await SharedPreferences.getInstance();
    String walletId = prefs.getString('wallet_id') ?? "";
    bool biometricEnabled = prefs.getBool('isbiometricenabled') ?? false;
    _isBiometricEnabled = biometricEnabled;
    _walletuserid = walletId;
    notifyListeners();
  }

  //
  //for setting page
  //

  Future<String> getBiometricLabel() async {
    final prefs = await SharedPreferences.getInstance();
    final isBiometricEnabled = prefs.getBool('isbiometricenabled') ?? false;
    return isBiometricEnabled ? "Disable Biometric" : "Enable Biometric";
  }

  Future<String> getTransactionPinLabel() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString('transaction_pin');
    return (pin == null || transactionpin_backend == false)
        ? "Change Transaction PIN"
        : "Setup Transaction PIN";
  }

  // Set transaction PIN
  Future<void> setTransactionPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('transaction_pin', pin);
    _transactionPin = pin;
    notifyListeners();
  }

  // Get the stored transaction pin
  Future<void> loadtranscationpin() async {
    final prefs = await SharedPreferences.getInstance();
    _transactionPin = prefs.getString('transaction_pin');
    notifyListeners();
  }

  // 👀 toogle show balance 👀

  void toogleShowBalance() {
    showbalance = !showbalance;
    notifyListeners();
  }

  void setwalletidfromsharedpreftowalletidvariable(
      String walletidfromsharedpref) {
    _walletuserid = walletidfromsharedpref;
    notifyListeners();
  }

  // 👀  Save Wallet ID to SharedPreferences 👀

  Future<void> _savewalletuserid(String walletuserid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("wallet_id", walletuserid);
  }

  // 👀 Register User & update Data 👀

  Future<void> registerUser(
      BuildContext context, String name, String email, String password) async {
    print("register user called");
    final response = await http.post(
      Uri.parse("$baseUrl/user/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    print("waiting for reponse body register user post request done");

    final responseData = jsonDecode(response.body);
    print(responseData);
    if (response.statusCode == 201) {
      print(
          "User registered successfully and here is the response data!!!! ............{{{{{}}}}}}}]]]]]]] data :::::::"
          "$responseData");
      _setDataOfUseronLoginAndSignUp(responseData["user"]);
      await _savewalletuserid(_walletuserid);
      notifyListeners();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainNavigation(),
        ),
        (route) => false,
      );

      // PersistentNavBarNavigator.pushNewScreen(
      //   context,
      //   screen: MainNavigation(),
      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      //   withNavBar: true,
      // );
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
        "type": "user",
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

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainNavigation(),
        ),
        (route) => false,
      );

      // // Now navigate to MainNavigation
      // PersistentNavBarNavigator.pushNewScreen(
      //   context,
      //   screen: MainNavigation(),
      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      //   withNavBar: true,
      // );
    } else {
      String errorMessage =
          jsonDecode(response.body)["message"] ?? "Login failed";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

//👀 Function to set transaction PIN 👀
  Future<void> setupTransactionPin(
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
        //save pin locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('transaction_pin', transactionPin);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigation(),
          ),
          (route) => false,
        );

        // PersistentNavBarNavigator.pushNewScreen(
        //   context,
        //   screen: MainNavigation(),
        //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
        //   withNavBar: false,
        // );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transaction PIN set successfully!")),
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
        Uri.parse("$baseUrl/transactions/user/$_walletuserid"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print("fetchTransaction response incoming:");
        print(response.body);

        List<dynamic> transactions = jsonDecode(response.body)['transactions'];

        _transactions = transactions.map((transaction) {
          // Use entityId instead of _id, and details.name instead of name
          bool isCredit = transaction['receiver']['entityId'] == _walletuserid;
          return {
            ...transaction,
            'isCredit': isCredit,
            'senderId': transaction['sender']['entityId'],
            'receiverId': transaction['receiver']['entityId'],
            'senderName': transaction['sender']['details']['name'],
            'receiverName': transaction['receiver']['details']['name'],
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

    if (_balance == 0.00) {
      // Assuming -1 is an invalid balance
      _balance = (data['balance'] ?? 0).toDouble();
    }

    if (_email.isEmpty) {
      _email = data['email'] ?? "";
    }

    _balance = (data['balance'] ?? 0).toDouble();

    _kycStatus = data['kycStatus'] ?? "Pending";
    _dob = data['dateOfBirth'] ?? "";
    _citizenidno = data['governmentIdNumber'] ?? "";

    print("kyc status: $_kycStatus");
    print("dob: $_dob");
    print("citizenidno: $_citizenidno");

    // Debugging prints
    print("Updated User Info:");
    print("Full Name: $_fullName");
    print("Wallet User ID: $_walletuserid");
    print("Balance: $_balance");
    print("Email: $_email");
    // print("kycstatus": _kycStatus);

    notifyListeners();
  }

  Future<void> sendMoney(
    BuildContext context,
    String receiverId,
    double amount,
    String pin,
    String TranscationType,
    String Remarks,
  ) async {
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
          "description": Remarks,
        }),
      );

      print(response.body);

      if (response.statusCode == 201) {
        // final data = jsonDecode(response.body);
        getBalance();
        // _balance = (data['user']['balance'] ?? -1).toDouble();
        // notifyListeners();

        // Navigate first, then show success message
        if (context.mounted) {
          // PersistentNavBarNavigator.pushNewScreen(
          //   context,
          //   screen: MainNavigation(),
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          //   withNavBar: true,
          // );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainNavigation(),
            ),
            (route) => false,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Transaction Successful")),
          );
        }
      } else {
        final errorMessage =
            jsonDecode(response.body)['msg'] ?? "Transaction failed";
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
        //once kyc updated call fetch user info to get latest user data
        fetchUserInfo();
        //navigate to main navigation
        PersistentNavBarNavigator.pushNewScreen(context,
            screen: MainNavigation(),
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
            withNavBar: true);
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
    await prefs.setBool('isbiometricenabled', false);

    print("SharedPreferences cleared");

    //5second delay before navigating to login screen

    await Future.delayed(const Duration(seconds: 1), () {
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: LoginScreen(),
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
        withNavBar: false,
      );
    });
  }
}
