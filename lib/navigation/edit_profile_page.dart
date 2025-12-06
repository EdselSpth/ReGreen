import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const Color kGreenDark = Color(0xFF558B3E);
  static const Color kCream = Color(0xFFE8EDDE);
  static const Color kGreenLight = Color(0xFFDDE7CC);

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final addrC = TextEditingController();
  final passC = TextEditingController();

  bool _isLoading = false;

  File? _imageFile;
  String? _currentPhotoBase64;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    addrC.dispose();
    passC.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && mounted) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            nameC.text = data['username'] ?? '';
            emailC.text = data['email'] ?? '';
            phoneC.text = data['phoneNumber'] ?? '';
            addrC.text = data['address'] ?? '';
            _currentPhotoBase64 = data['photoBase64'];
          });
        }
      } catch (e) {
        debugPrint('Gagal load data: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
        maxWidth: 400,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil gambar dari galeri')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (nameC.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong')));
      return;
    }

    setState(() => _isLoading = true);
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        String? base64Image;

        if (_imageFile != null) {
          List<int> imageBytes = await _imageFile!.readAsBytes();
          base64Image = base64Encode(imageBytes);
        }

        Map<String, dynamic> dataToUpdate = {
          'username': nameC.text,
          'phoneNumber': phoneC.text,
          'address': addrC.text,
        };

        if (base64Image != null) {
          dataToUpdate['photoBase64'] = base64Image;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(dataToUpdate);

        if (passC.text.isNotEmpty) {
          if (passC.text.length < 6) {
            throw FirebaseAuthException(
              code: 'weak-password',
              message: 'Password minimal 6 karakter',
            );
          }
          await user.updatePassword(passC.text);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil berhasil diperbarui!'),
              backgroundColor: kGreenDark,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        debugPrint("Error saving profile: $e");
        String message = 'Gagal menyimpan perubahan.';
        if (e.toString().contains('requires-recent-login')) {
          message = 'Untuk ganti password, mohon logout dan login kembali.';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        }
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;

    if (_imageFile != null) {
      backgroundImage = FileImage(_imageFile!);
    } else if (_currentPhotoBase64 != null && _currentPhotoBase64!.isNotEmpty) {
      try {
        backgroundImage = MemoryImage(base64Decode(_currentPhotoBase64!));
      } catch (e) {
        backgroundImage = const AssetImage('Assets/profile1.jpeg');
      }
    } else {
      backgroundImage = const AssetImage('Assets/profile1.jpeg');
    }

    return Scaffold(
      backgroundColor: kGreenDark,
      body: SafeArea(
        child: Column(
          children: [
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
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kGreenLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                _fieldLabel('Nama'),
                                _filledField(controller: nameC),
                                const SizedBox(height: 12),
                                _fieldLabel('Email'),
                                _filledField(
                                  controller: emailC,
                                  keyboardType: TextInputType.emailAddress,
                                  isReadOnly: true,
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
                                _fieldLabel('Password Baru (Opsional)'),
                                _filledField(
                                  controller: passC,
                                  obscure: true,
                                  hint: 'Isi jika ingin ganti password',
                                ),
                                const SizedBox(height: 24),
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
                                    onPressed: _isLoading ? null : _saveProfile,
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'Simpan Perubahan',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -40,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 42,
                                    backgroundColor: kCream,
                                    child: CircleAvatar(
                                      radius: 38,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage: backgroundImage,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: _pickImage,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: kGreenDark,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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

  Widget _fieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 6, bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  Widget _filledField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscure = false,
    int maxLines = 1,
    bool isReadOnly = false,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      maxLines: maxLines,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: isReadOnly
            ? Colors.grey.shade300
            : Colors.white.withOpacity(0.6),
        hintText: hint ?? '',
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: isReadOnly ? Colors.grey.shade600 : Colors.black,
      ),
    );
  }
}
