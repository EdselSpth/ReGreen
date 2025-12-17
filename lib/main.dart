import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:regreen/onboarding/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:regreen/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final pref = await SharedPreferences.getInstance();

  final bool seenOnboarding = pref.getBool('seenOnboarding') ?? false;

  runApp(MyApp(seenOnboarding: seenOnboarding));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.seenOnboarding});

  final bool seenOnboarding;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReGreen Apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: seenOnboarding ? const LoginScreen() : const LandingPage(),
    );
  }
}
