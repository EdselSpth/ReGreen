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

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final jalanController = TextEditingController();
  final kecamatanController = TextEditingController();
  final kelurahanaController = TextEditingController();
  final kotaController = TextEditingController();
  final provinsiController = TextEditingController();

  final nomerRekeningController = TextEditingController();
  final namaBankController = TextEditingController();

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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    jalanController.dispose();
    kecamatanController.dispose();
    kelurahanaController.dispose();
    kotaController.dispose();
    provinsiController.dispose();
    nomerRekeningController.dispose();
    namaBankController.dispose();
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
            nameController.text = data['username'] ?? '';
            emailController.text = data['email'] ?? '';
            phoneController.text = data['phoneNumber'] ?? '';
            _currentPhotoBase64 = data['photoBase64'];

            if (data['address'] != null && data['address'] is Map) {
              Map<String, dynamic> addr = data['address'];
              jalanController.text = addr['jalan'] ?? '';
              kecamatanController.text = addr['kecamatan'] ?? '';
              kelurahanaController.text = addr['kelurahan'] ?? '';
              kotaController.text = addr['kota'] ?? '';
              provinsiController.text = addr['provinsi'] ?? '';
            }

            if (data['bankAccount'] != null && data['bankAccount'] is Map) {
              Map<String, dynamic> bankAcc = data['bankAccount'];
              nomerRekeningController.text = bankAcc['accountNumber'] ?? '';
              namaBankController.text = bankAcc['bankName'] ?? '';
            }
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
    }
  }

  Future<void> _saveProfile() async {
    if (nameController.text.isEmpty) {
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
          'username': nameController.text,
          'phoneNumber': phoneController.text,
          'address': {
            'jalan': jalanController.text,
            'kecamatan': kecamatanController.text,
            'kelurahan': kelurahanaController.text,
            'kota': kotaController.text,
            'provinsi': provinsiController.text,
          },
          'bankAccount': {
            'accountNumber': nomerRekeningController.text,
            'bankName': namaBankController.text,
          },
        };

        if (base64Image != null) {
          dataToUpdate['photoBase64'] = base64Image;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(dataToUpdate);

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
        debugPrint("Error: $e");
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
      // 1. Scaffold tetap menggunakan kGreenDark agar area Status Bar di atas tetap hijau
      backgroundColor: kGreenDark,
      body: Column(
        children: [
          // 2. Gunakan SafeArea HANYA untuk bagian atas (Header)
          SafeArea(
            bottom: false, // Matikan safe area bawah di sini
            child: Padding(
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
          ),

          // 3. CONTENT SECTION
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: kCream, // Warna krem dimulai dari sini
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              // Tambahkan Column di dalam Container krem untuk menampung ScrollView dan SafeArea bawah
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 26,
                                vertical: 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // --- Bagian Stack Profil & Form ---
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: kGreenLight,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          60,
                                          16,
                                          16,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 16),
                                            _fieldLabel('Nama'),
                                            _filledField(
                                              controller: nameController,
                                            ),
                                            const SizedBox(height: 12),
                                            _fieldLabel('Email'),
                                            _filledField(
                                              controller: emailController,
                                              isReadOnly: true,
                                            ),
                                            const SizedBox(height: 12),
                                            _fieldLabel('No Telepon'),
                                            _filledField(
                                              controller: phoneController,
                                              keyboardType: TextInputType.phone,
                                            ),
                                            const SizedBox(height: 16),
                                            _fieldLabel('Alamat Lengkap'),
                                            const SizedBox(height: 6),
                                            _fieldLabel('Nama Jalan'),
                                            _filledField(
                                              controller: jalanController,
                                            ),
                                            const SizedBox(height: 12),
                                            _fieldLabel('Kelurahan'),
                                            _filledField(
                                              controller: kelurahanaController,
                                            ),
                                            const SizedBox(height: 12),
                                            _fieldLabel('Kecamatan'),
                                            _filledField(
                                              controller: kecamatanController,
                                            ),
                                            const SizedBox(height: 12),
                                            _fieldLabel('Kota'),
                                            _filledField(
                                              controller: kotaController,
                                            ),
                                            const SizedBox(height: 12),
                                            _fieldLabel('Provinsi'),
                                            _filledField(
                                              controller: provinsiController,
                                            ),
                                            const SizedBox(height: 12),
                                            _fieldLabel('Nomer Rekening'),
                                            _filledField(
                                              controller:
                                                  nomerRekeningController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            const SizedBox(height: 12),
                                            _fieldLabel('Nama Bank'),
                                            _filledField(
                                              controller: namaBankController,
                                            ),
                                            const SizedBox(height: 24),
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: kGreenDark,
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: _isLoading
                                                    ? null
                                                    : _saveProfile,
                                                child: _isLoading
                                                    ? const SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                              strokeWidth: 2,
                                                            ),
                                                      )
                                                    : const Text(
                                                        'Simpan Perubahan',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: -10,
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
                                                  backgroundImage:
                                                      backgroundImage,
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: _pickImage,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
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
                        );
                      },
                    ),
                  ),

                  const SafeArea(top: false, child: SizedBox(height: 12)),
                ],
              ),
            ),
          ),
        ],
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
    bool isReadOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: isReadOnly
            ? Colors.grey.shade300
            : Colors.white.withOpacity(0.6),
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
