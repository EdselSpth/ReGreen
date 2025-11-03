import 'package:flutter/material.dart';
import 'package:regreen/auth/login_screen.dart';
import 'package:regreen/forgetpassword/codeverification.dart';

class EmailVerifikasiPage extends StatefulWidget {
  const EmailVerifikasiPage({super.key});

  @override
  State<EmailVerifikasiPage> createState() => _EmailVerifikasiPageState();
}

class _EmailVerifikasiPageState extends State<EmailVerifikasiPage> {
  final TextEditingController _emailController = TextEditingController();

  void _kirimEmail() {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      // Jika kosong, tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email tidak boleh kosong!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Jika terisi, lanjut ke halaman berikutnya
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CodeVerificationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3E5),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Re',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B7C87),
                        ),
                      ),
                      const TextSpan(
                        text: 'Green',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C8D4C),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                Column(
                  children: const [
                    Text(
                      "|0||0|",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5C8D4C),
                        letterSpacing: 3,
                      ),
                    ),
                    Icon(
                      Icons.vpn_key_rounded,
                      size: 60,
                      color: Color(0xFF8CC63F),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  "Silakan isi email yang\nterdaftar untuk verifikasi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'sans-serif',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 24),

                // Input Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFDCE1CF),
                    hintText: "Email",
                    hintStyle: const TextStyle(
                      color: Color(0xFF3E403A),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Tombol Kirim
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _kirimEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C8D4C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      "Kirim",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Link Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sudah punya akun? ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xFF5C8D4C),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
