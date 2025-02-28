import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/auth/biometric_auth.dart';
import 'package:cbdc/screens/main_navigation.dart';
import 'package:cbdc/screens/auth/signup_screen.dart';
import 'package:cbdc/screens/utils/kycverification.dart';
import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:cbdc/provider/userprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cbdc/provider/theme_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool showbiometric = false;

  void _loginuser() async {
    print("loginfunc called");

    final userprovider = Provider.of<UserProvider>(context, listen: false);
    await userprovider.loginUser(
        context, emailController.text, passwordController.text);
    print("loginfunc called");
  }

  @override
  void initState() {
    super.initState();

    // Ensure the keyboard opens automatically after logout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
    });

    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

    prefs.then((SharedPreferences prefs) {
      String isloggedin = prefs.getString('wallet_id') ?? "";
      bool isbiometricenabled = prefs.getBool('isbiometricenabled') ?? false;

      if (isloggedin.isNotEmpty && isbiometricenabled) {
        setState(() {
          showbiometric = true;
        });
      } else {
        setState(() {
          showbiometric = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, value, child) => value.walletuserid.isNotEmpty
            ? MainNavigation()
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [
                              Colors.black,
                              Colors.grey[900]!,
                            ] // 👀 Apply dark gradient
                          : [
                              Colors.white,
                              Colors.white
                            ], // 👀 Keep white for light mode
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top + 80),
                      Container(
                        alignment: Alignment.center,
                        // margin: EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          'CBDC',
                          style: TextStyle(
                            // color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            gradient: LinearGradient(
                              colors: isDarkMode
                                  ? [
                                      Colors.black,
                                      Colors.grey[900]!,
                                    ] // 👀 Apply dark gradient
                                  : [
                                      Colors.white,
                                      Colors.white
                                    ], // 👀 Keep white for light mode
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          // decoration: BoxDecoration(
                          //   color: isDarkMode ? Colors.black12 : Colors.white,
                          //   borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(30),
                          //     topRight: Radius.circular(30),
                          //   ),
                          // ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    prefixIcon: const Icon(Icons.email),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      print("login button pressed");
                                      _loginuser();
                                    },
                                    child: const Text('Sign In'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: SignupScreen(),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    },
                                    child: const Text('Sign Up'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                    ),
                                  ),
                                ),
                                //Biometric option

                                showbiometric
                                    ? GestureDetector(
                                        onTap: () => Biometricauth()
                                            .checkBiometric(
                                                context,
                                                MainNavigation(),
                                                LoginScreen(),
                                                false),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.fingerprint,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 10),
                                            const Text(
                                              'Tap to login with biometric',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
