import 'package:flutter/material.dart';
import 'package:regreen/auth/login_screen.dart';

class ResetPasswordMain extends StatefulWidget {
  const ResetPasswordMain({super.key});

  @override
  State<ResetPasswordMain> createState() => _ResetPasswordMainState();
}

class _ResetPasswordMainState extends State<ResetPasswordMain> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  void _konfirmasiPassword() {
    String password = _passwordController.text.trim();
    String konfirmasi = _confirmController.text.trim();

    // Validasi isi kolom
    if (password.isEmpty || konfirmasi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua kolom harus diisi!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Validasi kesamaan password
    if (password != konfirmasi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password dan konfirmasi tidak sama!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Jika valid, tampilkan snackbar sukses lalu arahkan ke login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password Anda berhasil diubah."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Delay sedikit agar snackbar tampil dulu sebelum pindah
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  void _batalkan() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EDDD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Logo ReGreen
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

                // Ikon
                const Icon(
                  Icons.lock_reset_rounded,
                  size: 100,
                  color: Color(0xFF9FD36C),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Masukan password baru',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                // Input Password Baru
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password Baru",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E403A),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFD8DDCD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Input Konfirmasi Password
                TextField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Konfirmasi Password Baru",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E403A),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFD8DDCD),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Tombol Konfirmasi
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF558B3E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _konfirmasiPassword,
                    child: const Text(
                      'Konfirmasi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tombol Batalkan
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B7C87),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _batalkan,
                    child: const Center(
                      child: Text(
                        'Batalkan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
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
