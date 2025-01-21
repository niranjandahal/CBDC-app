import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String walletIdKey = "wallet_id";

  static Future<void> saveWalletId(String walletId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(walletIdKey, walletId);
  }

  static Future<String?> getWalletId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(walletIdKey);
  }

  static Future<void> clearWalletId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(walletIdKey);
  }
}
