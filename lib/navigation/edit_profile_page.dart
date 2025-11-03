import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Palet warna konsisten
  static const Color kGreenDark = Color(0xFF558B3E);
  static const Color kCream = Color(0xFFE8EDDE);
  static const Color kGreenLight = Color(0xFFDDE7CC);

  // Controller sederhana
  final nameC = TextEditingController(text: 'Edsel');
  final emailC = TextEditingController(text: 'edselspth@gmail.com');
  final phoneC = TextEditingController(text: '0851-5503-0650');
  final addrC = TextEditingController(
    text:
        'Komplek Taman Bumi Prima Blok O No 8, Kecamatan Cibabat, Kelurahan Cimahi Utara, Kota Cimahi 40513',
  );
  final passC = TextEditingController(text: '************');

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    addrC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreenDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header hijau
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(999),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Edit Profil Pengguna',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Layer krem rounded
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: kCream,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kartu besar hijau muda tempat form
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kGreenLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                const Center(
                                  child: Text(
                                    'Ubah Foto Profil',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                _fieldLabel('Nama'),
                                _filledField(controller: nameC),
                                const SizedBox(height: 12),

                                _fieldLabel('Email'),
                                _filledField(
                                  controller: emailC,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 12),

                                _fieldLabel('No Telepon'),
                                _filledField(
                                  controller: phoneC,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 12),

                                _fieldLabel('Alamat'),
                                _filledField(controller: addrC, maxLines: 3),
                                const SizedBox(height: 12),

                                _fieldLabel('Password'),
                                _filledField(controller: passC, obscure: true),
                                const SizedBox(height: 24),

                                // Tombol simpan
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kGreenDark,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      // TODO: simpan perubahan
                                    },
                                    child: const Text(
                                      'Ubah Profile',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Avatar bulat nyangkut di tepi kartu
                          Positioned(
                            top: -32,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 34,
                                  backgroundImage: const AssetImage(
                                    'assets/profile1.jpeg',
                                  ),
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
          ],
        ),
      ),
    );
  }

  // Label kecil di atas input
  Widget _fieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 6, bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  // TextFormField dengan fill hijau muda & sudut bulat
  Widget _filledField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscure = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      maxLines: maxLines,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white.withOpacity(
          0.6,
        ), // biar kontras di atas kGreenLight
        hintText: '',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kGreenDark, width: 1),
        ),
      ),
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }
}
