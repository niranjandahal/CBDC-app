// import 'package:cbdc/provider/theme_provider.dart';
// import 'package:cbdc/screens/transcations/recenttranscation.dart';
// import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
// import '../../widgets/balance_card.dart';
// import '../utils/send_money_screen.dart';
// import '../utils/receive_money_screen.dart';
// import '../utils/profile_screen.dart';
// import 'package:provider/provider.dart';

// class DashboardScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
//         automaticallyImplyLeading: false,
//         title: Text("CBDC Wallet",
//             style: TextStyle(
//               color: themeProvider.isDarkMode ? Colors.white : Colors.black54,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             )),
//         actions: [
//           // Dark Mode Toggle
//           themeProvider.isDarkMode
//               ? IconButton(
//                   icon: const Icon(
//                     Icons.light_mode,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     themeProvider.toggleTheme();
//                   },
//                 )
//               : IconButton(
//                   icon: const Icon(
//                     Icons.dark_mode,
//                     color: Colors.black87,
//                   ),
//                   onPressed: () {
//                     themeProvider.toggleTheme();
//                   },
//                 ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Use reusable BalanceCard
//               BalanceCard(),
//               const SizedBox(height: 30),
//               // Action Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _actionButton(
//                     context,
//                     "Send Money",
//                     Icons.send,
//                     Colors.blue,
//                     () => PersistentNavBarNavigator.pushNewScreen(
//                       context,
//                       screen: SendMoneyScreen(),
//                       withNavBar: false,
//                       pageTransitionAnimation:
//                           PageTransitionAnimation.cupertino,
//                     ),
//                   ),
//                   _actionButton(
//                     context,
//                     "Receive Money",
//                     Icons.qr_code_scanner,
//                     Colors.green,
//                     () => PersistentNavBarNavigator.pushNewScreen(
//                       context,
//                       screen: ReceiveMoneyScreen(),
//                       withNavBar: false,
//                       pageTransitionAnimation:
//                           PageTransitionAnimation.cupertino,
//                     ),
//                   ),
//                   _actionButton(
//                     context,
//                     "Profile",
//                     Icons.person,
//                     Colors.purple,
//                     () => PersistentNavBarNavigator.pushNewScreen(
//                       context,
//                       screen: ProfileScreen(),
//                       withNavBar: false,
//                       pageTransitionAnimation:
//                           PageTransitionAnimation.cupertino,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
//               // Recent Transactions
//               Text(
//                 "Recent Transactions",
//                 style: TextStyle(
//                   color:
//                       themeProvider.isDarkMode ? Colors.white : Colors.black54,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 height: 300,

//                 child: RecentTranscation()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _actionButton(BuildContext context, String title, IconData icon,
//       Color color, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: color.withOpacity(0.1),
//             child: Icon(icon, color: color, size: 28),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cbdc/provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:cbdc/provider/theme_provider.dart';
import 'package:cbdc/screens/transcations/recenttranscation.dart';
import '../../widgets/balance_card.dart';
import '../utils/send_money_screen.dart';
import '../utils/receive_money_screen.dart';
import '../utils/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> _refreshDashboard() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      

      await Future.wait([
        userProvider.fetchUserInfo(),
        userProvider.fetchTransactions(),
      ]);

      // Rebuild UI after fetching
      setState(() {});
    } catch (e) {
      debugPrint("Refresh error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to refresh. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "CBDC Wallet",
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black54,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        edgeOffset: 20,
        displacement: 40,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Required for refresh
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BalanceCard(), // Rebuilt on refresh
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton(
                    context,
                    "Send Money",
                    Icons.send,
                    Colors.blue,
                    () => PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const SendMoneyScreen(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    ),
                  ),
                  _actionButton(
                    context,
                    "Receive Money",
                    Icons.qr_code_scanner,
                    Colors.green,
                    () => PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: ReceiveMoneyScreen(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    ),
                  ),
                  _actionButton(
                    context,
                    "Profile",
                    Icons.person,
                    Colors.purple,
                    () => PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: ProfileScreen(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                "Recent Transactions",
                style: TextStyle(
                  color:
                      themeProvider.isDarkMode ? Colors.white : Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: RecentTranscation(), // Rebuilt on refresh
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
