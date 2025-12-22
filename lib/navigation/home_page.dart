import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regreen/penarikan_keuntungan/penarikan_keuntungan_page.dart';
import 'package:regreen/penarikan_keuntungan/status_penarikan_page.dart';
import 'dart:convert';
import 'package:regreen/penarikan_area/penarikan_area_page.dart';
import 'package:regreen/Model/area_status.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = 'ReGreeners';
  String? _photoBase64;

  bool _hideSaldo = true;

  AreaStatus _areaStatus = AreaStatus.notRegistered;
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

      final status = data?['areaStatus'];

      setState(() {
        _areaStatus = areaStatusFromString(status);
        _loadingArea = false;
      });
    } catch (e) {
      debugPrint("Error cek area: $e");
      if (mounted) {
        setState(() => _loadingArea = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String areaTitle = '';
    String areaDesc = '';
    bool showRegisterButton = false;

    switch (_areaStatus) {
      case AreaStatus.notRegistered:
        areaTitle = 'Areamu Belum Terdaftar?';
        areaDesc = 'Ayo daftarkan sekarang agar sampahmu dijemput!!';
        showRegisterButton = true;
        break;

      case AreaStatus.pending:
        areaTitle = 'Areamu Sedang Diverifikasi';
        areaDesc = 'Pendaftaran area kamu sedang ditinjau admin.';
        break;

      case AreaStatus.approved:
        areaTitle = 'Areamu Sudah Terdaftar 🎉';
        areaDesc =
            'Area $_userKecamatan sudah aktif.\nKamu bisa langsung melakukan penjemputan.';
        break;
    }
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
                              children: [
                                const Text(
                                  'SALDO',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(
                                        FirebaseAuth.instance.currentUser!.uid,
                                      )
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text(
                                        'Memuat...',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      );
                                    }

                                    if (!snapshot.hasData ||
                                        !snapshot.data!.exists) {
                                      return const Text('Rp 0');
                                    }

                                    final data =
                                        snapshot.data!.data()
                                            as Map<String, dynamic>;
                                    final saldo = (data['balance'] ?? 0)
                                        .toInt();

                                    return Row(
                                      children: [
                                        Text(
                                          _hideSaldo
                                              ? 'Rp ••••••••'
                                              : formatRupiah(saldo),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _hideSaldo = !_hideSaldo;
                                            });
                                          },
                                          child: Icon(
                                            _hideSaldo
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            size: 20,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
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
                      if (_loadingArea) ...[
                        const Center(child: CircularProgressIndicator()),
                      ] else if (!_hasValidAddress) ...[
                        _jadwalMessage(
                          'Lengkapi alamatmu terlebih dahulu untuk melihat jadwal pengambilan',
                        ),
                      ] else if (_areaStatus != AreaStatus.approved) ...[
                        _jadwalMessage(
                          _areaStatus == AreaStatus.pending
                              ? 'Area kamu sedang diverifikasi'
                              : 'Alamatmu belum terdaftar di area pengambilan',
                        ),
                      ] else ...[
                        // === JADWAL PENGAMBILAN (APPROVED ONLY) ===
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
                            color: Color(0xFFDDE7CC),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Text('Jadwal di sini'),
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
                                areaTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),

                              const SizedBox(height: 4),
                              Text(
                                areaDesc,
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),

                              if (showRegisterButton) ...[
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF558B3E),
                                  ),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const PendaftaranAreaPage(),
                                      ),
                                    );

                                    if (result == true) {
                                      _checkUserArea(); // refresh status
                                    }
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

  String formatRupiah(int value) {
    final String number = value.toString();
    final StringBuffer buffer = StringBuffer();
    int counter = 0;

    for (int i = number.length - 1; i >= 0; i--) {
      buffer.write(number[i]);
      counter++;
      if (counter % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }
}
