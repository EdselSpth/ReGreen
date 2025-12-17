import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:regreen/onboarding/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:regreen/auth/login_screen.dart';
import 'package:regreen/navigation/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final pref = await SharedPreferences.getInstance();

  final bool seenOnboarding = pref.getBool('seenOnboarding') ?? false;

  final bool rememberMe = pref.getBool('remember_me') ?? false;

  runApp(MyApp(seenOnboarding: seenOnboarding, rememberMe: rememberMe));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.seenOnboarding,
    required this.rememberMe,
  });
  final bool seenOnboarding;
  final bool rememberMe;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReGreen Apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: _getStartScreen(),
    );
  }

  Widget _getStartScreen() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && rememberMe) {
      return const MainScreen();
    } else {
      if (user != null && !rememberMe) {
        FirebaseAuth.instance.signOut();
      }
      if (seenOnboarding) {
        return const LoginScreen();
      } else {
        return const LandingPage();
      }
    }
  }
}
