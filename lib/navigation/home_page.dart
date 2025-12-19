import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regreen/penarikan_keuntungan/penarikan_keuntungan_page.dart';
import 'package:regreen/penarikan_keuntungan/status_penarikan_page.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = 'ReGreeners';
  String? _photoBase64;

  bool _isAreaRegistered = false;
  bool _loadingArea = true;
  String? _userKecamatan;

  bool _hasValidAddress = false;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _checkUserArea();
  }

  Future<void> _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey('username')) {
            if (mounted) {
              setState(() {
                _userName = data['username'];
                _photoBase64 = data['photoBase64'];
              });
            }
          }
        }
      } catch (e) {
        debugPrint("Error mengambil data user: $e");
      }
    }
  }

  Future<void> _checkUserArea() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        if (mounted) {
          setState(() => _loadingArea = false);
        }
        return;
      }

      final data = userDoc.data();
      final address = data?['address'];

      if (address == null || address['kecamatan'] == null) {
        if (mounted) {
          setState(() {
            _hasValidAddress = false;
            _loadingArea = false;
          });
        }
        return;
      }

      _hasValidAddress = true;
      _userKecamatan = address['kecamatan'];

      final areaSnapshot = await FirebaseFirestore.instance
          .collection('registered_areas')
          .where('kecamatan', isEqualTo: _userKecamatan)
          .limit(1)
          .get();

      if (mounted) {
        setState(() {
          _isAreaRegistered = areaSnapshot.docs.isNotEmpty;
          _loadingArea = false;
        });
      }
    } catch (e) {
      debugPrint("Error cek area: $e");
      if (mounted) {
        setState(() => _loadingArea = false);
      }
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
      backgroundColor: const Color(0xFF558B3E),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 45, 30, 45),
              child: Row(
                children: [
                  CircleAvatar(radius: 30, backgroundImage: profileImage),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang, $_userName',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Mau Setor Apa Hari Ini?',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8EDDE),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDE7CC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'SALDO',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Rp. 200.000.000,00',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PenarikanKeuntunganPage(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF558B3E),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StatusPenarikanPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDDE7CC),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: const [
                              Icon(Icons.history, color: Color(0xFF558B3E)),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Cek Status Penarikan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),
                      const Divider(color: Colors.black26, thickness: 1),
                      const SizedBox(height: 18),
                      if (_loadingArea) ...[
                        const Center(child: CircularProgressIndicator()),
                      ] else if (!_hasValidAddress) ...[
                        _jadwalMessage(
                          'Lengkapi alamatmu terlebih dahulu untuk melihat jadwal pengambilan',
                        ),
                      ] else if (!_isAreaRegistered) ...[
                        _jadwalMessage(
                          'Alamatmu belum terdaftar di area pengambilan',
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Jadwal Pengambilan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Detail',
                              style: TextStyle(
                                color: Color(0xFF558B3E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFDDE7CC),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Senin, 19 Mei 2025',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '07:00 - 09:00',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Sampah : Organik, Plastik\nKurir : Abdul Azis Saepurohmat',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'Assets/kurir.jpg',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _actionButton(
                              icon: Icons.attach_money,
                              label: 'Tarik Keuntungan',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PenarikanKeuntunganPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _actionButton(
                              icon: Icons.calendar_month,
                              label: 'Daftar Pengambilan',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDE7CC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            if (_loadingArea)
                              const CircularProgressIndicator()
                            else ...[
                              Text(
                                _isAreaRegistered
                                    ? 'Areamu Sudah Terdaftar 🎉'
                                    : 'Areamu Belum Terdaftar?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _isAreaRegistered
                                    ? 'Area $_userKecamatan sudah aktif.\nKamu bisa langsung melakukan penjemputan.'
                                    : 'Ayo daftarkan sekarang agar sampahmu dijemput!!',
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                              if (!_isAreaRegistered) ...[
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF558B3E),
                                  ),
                                  onPressed: () {
                                    // ke halaman daftar area
                                  },
                                  child: const Text(
                                    'Daftar Sekarang!!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
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

  Widget _actionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFDDE7CC),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF558B3E), size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jadwalMessage(String text) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFDDE7CC),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}
