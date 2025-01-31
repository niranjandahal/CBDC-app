import 'package:cbdc/authentication/auth.dart';
import 'package:cbdc/provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbdc/provider/theme_provider.dart';
import 'package:cbdc/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
    child: CBDCApp(),
  ));
}

class CBDCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CBDC App',
            builder: (context, child) {
              return ForcedMobileView(child: child!);
            },
            theme: themeProvider.isDarkMode
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            home: const AuthHandler(),
          );
        },
      ),
    );
  }
}

class ForcedMobileView extends StatelessWidget {
  final Widget child;

  const ForcedMobileView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    const double mobileWidth = 420;
    const double mobileHeight = 900;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenWidth > mobileWidth || screenHeight > mobileHeight) {
      return Column(
        children: [
          const Text(
            'Zoom out your browser to view the full screen.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const Text(
            'Some features might not work as intended on the web.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: mobileWidth,
              height: mobileHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5), blurRadius: 10),
                ],
              ),
              child: MediaQuery(
                data: MediaQueryData(
                  size: const Size(mobileWidth, mobileHeight),
                  devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
                  padding: MediaQuery.of(context).padding,
                  viewInsets: MediaQuery.of(context).viewInsets,
                ),
                child: child,
              ),
            ),
          ),
        ],
      );
    }

    return child;
  }
}
