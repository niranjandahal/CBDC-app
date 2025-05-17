import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/auth/biometric_auth.dart';
import 'package:cbdc/screens/main_navigation.dart';
import 'package:cbdc/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tuple/tuple.dart';
import 'package:provider/provider.dart';
import 'package:cbdc/provider/theme_provider.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _loginuser() async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    await userprovider.loginUser(
        context, emailController.text, passwordController.text);
  }

  @override
  void initState() {
    super.initState();
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    userprovider.checkBiometricLoginAvailable();
    print("checkbiometric login function called in login screen via initstate");
  }

  @override
  Widget build(BuildContext context) {
    print(
        "this is the main login screen widget tree let's see how many times it built");
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    screen: SignupScreen(),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino);
                              },
                              child: const Text('Sign Up'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                          Selector<UserProvider, Tuple2<bool, String>>(
                            selector: (_, provider) => Tuple2(
                                provider.isbiometricenabled,
                                provider.walletuserid),
                            builder: (context, selected, child) {
                              final isBiometricEnabled = selected.item1;
                              final walletUserId = selected.item2;

                              print(
                                  "Selector rebuilt: biometric=$isBiometricEnabled, walletId=$walletUserId");

                              if (isBiometricEnabled &&
                                  walletUserId.isNotEmpty) {
                                return GestureDetector(
                                  onTap: () async {
                                    Biometricauth().handleBiometricAction(
                                      context: context,
                                      isForSetup: false,
                                      onSuccess: () {
                                        PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: MainNavigation(),
                                          withNavBar: true,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.cupertino,
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.fingerprint,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                      const SizedBox(width: 15),
                                      Text(
                                        'Tap to login with biometric',
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }
}
