import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:regreen/forgetpassword/resetpasswordmain.dart';

class CodeVerificationPage extends StatefulWidget {
  const CodeVerificationPage({super.key});

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  // Pastikan list controller dibuat sebanyak 6
  final _controllers = List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifikasiKode() {
    String kode = _controllers.map((c) => c.text.trim()).join();

    // Validasi untuk 6 digit
    if (kode.length < 6 || kode.contains(RegExp(r'[^0-9]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi semua 6 kotak dengan angka!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResetPasswordMain()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3E5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ), // Padding dikurangi sedikit agar muat
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
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

              const Icon(
                Icons.mark_email_unread_rounded,
                color: Color(0xFF7CB342),
                size: 90,
              ),

              const SizedBox(height: 20),

              // PERBAIKAN: Ubah teks jadi 6 digit
              const Text(
                "Masukan 6 digit verifikasi dari\nemail anda",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 45,
                    height: 50,
                    child: TextField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical
                          .center, // Pastikan kursor di tengah vertikal
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: const Color(0xFFDCE1CF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.zero, // Penting agar teks pas di tengah
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      onChanged: (value) {
                        // Logika pindah fokus
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _verifikasiKode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C8D4C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    "Kirim",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // ... sisa kode bawah sama (tombol kirim ulang dll) ...
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Tidak menerima kode? ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kode dikirim ulang')),
                      );
                    },
                    child: const Text(
                      "Kirim ulang kode",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5C8D4C),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
