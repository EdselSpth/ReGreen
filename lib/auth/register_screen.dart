import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:regreen/widget/custom_textfeld.dart';

const Color kBackground = Color(0xFFE8EDDE);
const Color kGreenButton = Color(0xFF548A3C);
const Color kGreenText = Color(0xFF3B5B4F);
const Color kTextFieldBackground = Color(0xFFCFD4C6);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                const Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Buat akun dan\nmulai jual sampahmu!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Konfirmasi Password',
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logika pendaftaran akan ditambahkan di sini
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreenButton,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Daftar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(color: kGreenText, fontSize: 16),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: kGreenButton,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
