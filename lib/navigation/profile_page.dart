import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:regreen/auth/login_screen.dart';
import 'package:regreen/navigation/edit_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regreen/Service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const Color kGreenDark = Color(0xFF558B3E);
  static const Color kCream = Color(0xFFE8EDDE);
  static const Color kGreenLight = Color(0xFFDDE7CC);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = 'Loading...';
  String _email = 'Loading...';
  String _phoneNumber = '-';
  String _address = '-';
  String _joinYear = '...';
  String? _photoBase64;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _refreshData() async {
    await _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

          String yearResult = DateTime.now().year.toString();

          if (data != null && data['joinDate'] != null) {
            if (data['joinDate'] is Timestamp) {
              Timestamp timestamp = data['joinDate'];
              yearResult = timestamp.toDate().year.toString();
            }
          }

          String fullAddress = '-';

          if (data != null &&
              data['address'] != null &&
              data['address'] is Map) {
            Map<String, dynamic> addr = data['address'];

            List<String> addressParts = [];

            if (addr['jalan'] != null && addr['jalan'].toString().isNotEmpty)
              addressParts.add(addr['jalan']);
            if (addr['kelurahan'] != null &&
                addr['kelurahan'].toString().isNotEmpty)
              addressParts.add(addr['kelurahan']);
            if (addr['kecamatan'] != null &&
                addr['kecamatan'].toString().isNotEmpty)
              addressParts.add(addr['kecamatan']);
            if (addr['kota'] != null && addr['kota'].toString().isNotEmpty)
              addressParts.add(addr['kota']);
            if (addr['provinsi'] != null &&
                addr['provinsi'].toString().isNotEmpty)
              addressParts.add(addr['provinsi']);
            if (addressParts.isNotEmpty) {
              fullAddress = addressParts.join(', ');
            }
          } else {
            fullAddress = data?['address'] ?? '-';
          }

          if (mounted) {
            setState(() {
              _username = data?['username'] ?? 'No Name';
              _email = data?['email'] ?? 'No Email';
              _phoneNumber = data?['phoneNumber'] ?? '-';

              _address = fullAddress;

              _joinYear = yearResult;
              _photoBase64 = data?['photoBase64'];
            });
          }
        }
      } catch (e) {
        debugPrint('Gagal mengambil data profil: $e');
      }
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider profileImage;
    if (_photoBase64 != null && _photoBase64!.isNotEmpty) {
      try {
        profileImage = MemoryImage(base64Decode(_photoBase64!));
      } catch (e) {
        profileImage = const AssetImage('Assets/profile1.jpeg');
      }
    } else {
      profileImage = const AssetImage('Assets/profile1.jpeg');
    }

    return Scaffold(
      backgroundColor: ProfilePage.kGreenDark,
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
                      'Profil Pengguna',
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
                  color: ProfilePage.kCream,
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
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: profileImage,
                            ),
                            border: Border.all(
                              color: ProfilePage.kGreenDark,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      Center(
                        child: Column(
                          children: [
                            Text(
                              _username,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Bergabung Sejak $_joinYear',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Informasi Pribadi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditProfilePage(),
                                ),
                              );
                              await _refreshData();
                            },
                            child: const Text(
                              'Edit Profil',
                              style: TextStyle(
                                color: ProfilePage.kGreenDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildInfoCard(
                        icon: Icons.email,
                        title: 'Email',
                        content: _email,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.phone,
                        title: 'No. Telepon',
                        content: _phoneNumber,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.location_on,
                        title: 'Alamat',
                        content: _address,
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        'Lainnya',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: _logout,
                        child: _buildInfoCard(
                          icon: Icons.exit_to_app,
                          title: 'Keluar',
                          content: '',
                        ),
                      ),

                      const SizedBox(height: 16),
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ProfilePage.kGreenLight,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                if (content.isNotEmpty)
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
