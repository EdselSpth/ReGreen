import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:regreen/penarikan_keuntungan/penarikan_keuntungan_page.dart';
import 'package:regreen/penarikan_keuntungan/status_penarikan_page.dart';
import 'package:regreen/penarikan_area/penarikan_area_page.dart';
import 'package:regreen/Model/area_status.dart';
import 'package:regreen/Service/schedule_service.dart';
import 'package:regreen/Model/penjemputan_model.dart';
import 'package:regreen/navigation/schedule_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScheduleService _scheduleService = ScheduleService();

  String _userName = 'ReGreeners';
  String? _photoBase64;
  bool _hideSaldo = true;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) return;

      final data = userDoc.data();
      if (data == null) return;

      if (mounted) {
        setState(() {
          _userName = data['username'] ?? 'ReGreeners';
          _photoBase64 = data['photoBase64'];
        });
      }
    } catch (e) {
      debugPrint('Error fetch username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider profileImage;
    if (_photoBase64 != null && _photoBase64!.isNotEmpty) {
      try {
        profileImage = MemoryImage(base64Decode(_photoBase64!));
      } catch (_) {
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
            /// HEADER
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

            /// BODY
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
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// SALDO
                        _saldoCard(),

                        const SizedBox(height: 12),

                        /// STATUS PENARIKAN
                        _statusPenarikanCard(),

                        const SizedBox(height: 18),

                        /// AREA STATUS + JADWAL (REALTIME)
                        _areaDanJadwal(),

                        const SizedBox(height: 18),

                        /// ACTION BUTTON
                        Row(
                          children: [
                            Expanded(
                              child: _actionButton(
                                icon: Icons.attach_money,
                                label: 'Tarik Keuntungan',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SchedulePage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 2),

                        // Banner Penolakan diletakkan di atas tombol daftar
                        _rejectionBanner(),

                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return const SizedBox();
                            }

                            final data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final address = data['address'];
                            final status = areaStatusFromString(
                              data['areaStatus'],
                            );

                            String? kecamatan;
                            if (address is Map) {
                              kecamatan = address['kecamatan'];
                            }

                            String title = '';
                            String desc = '';
                            bool showButton = false;

                            if (status == AreaStatus.notRegistered) {
                              title = 'Areamu Belum Terdaftar?';
                              desc =
                                  'Ayo daftarkan sekarang agar sampahmu dijemput!';
                              showButton = true;
                            } else if (status == AreaStatus.pending) {
                              title = 'Areamu Sedang Diverifikasi';
                              desc =
                                  'Pendaftaran area kamu sedang ditinjau admin.';
                            } else if (status == AreaStatus.approved) {
                              title = 'Areamu Sudah Terdaftar 🎉';
                              desc =
                                  'Area ${kecamatan ?? ""} sudah aktif.\nKamu bisa langsung melakukan penjemputan.';
                            } else {
                              return const SizedBox();
                            }

                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 18),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDDE7CC),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    desc,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  if (showButton) ...[
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF558B3E,
                                        ),
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
                                          setState(() {});
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
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===================== WIDGETS =====================

  Widget _saldoCard() {
    return Container(
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
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text('Rp 0');
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final saldo = (data['balance'] ?? 0).toInt();

                  return Row(
                    children: [
                      Text(
                        _hideSaldo ? 'Rp ••••••••' : formatRupiah(saldo),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => _hideSaldo = !_hideSaldo),
                        child: Icon(
                          _hideSaldo ? Icons.visibility_off : Icons.visibility,
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
                  builder: (_) => const PenarikanKeuntunganPage(),
                ),
              );
            },
            child: const CircleAvatar(
              backgroundColor: Color(0xFF558B3E),
              child: Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPenarikanCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StatusPenarikanPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFDDE7CC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(Icons.history, color: Color(0xFF558B3E)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Cek Status Penarikan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _areaDanJadwal() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _jadwalMessage('Data user tidak ditemukan');
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final address = data['address'];
        final status = areaStatusFromString(data['areaStatus']);

        if (address == null) {
          return _jadwalMessage('Lengkapi alamatmu terlebih dahulu');
        }

        if (status != AreaStatus.approved) {
          return _jadwalMessage(
            status == AreaStatus.pending
                ? 'Area kamu sedang diverifikasi oleh admin'
                : 'Alamatmu belum terdaftar di area pengambilan',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jadwal Pengambilan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            StreamBuilder<List<Penjemputan>>(
              stream: _scheduleService.getPenjemputanStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _jadwalMessage('Belum ada jadwal penjemputan');
                }

                final item = snapshot.data!.first;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SchedulePage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDE7CC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_shipping,
                          color: Color(0xFF558B3E),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.courierName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '📅 ${item.tanggal.toLocal().toString().split(" ")[0]} • ⏰ ${item.time}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                item.alamat,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _rejectionBanner() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists)
          return const SizedBox();

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final status = data['areaStatus'] ?? '';
        final reason = data['rejectionReason'] as String? ?? '';

        if (status == 'notRegistered' && reason.isNotEmpty) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 18),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFDDE7CC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade300, width: 1),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red.shade100,
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pendaftaran Area Ditolak",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        reason,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
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
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFDDE7CC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF558B3E)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _jadwalMessage(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE7CC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  String formatRupiah(int value) {
    final number = value.toString();
    final buffer = StringBuffer();
    int counter = 0;
    for (int i = number.length - 1; i >= 0; i--) {
      buffer.write(number[i]);
      counter++;
      if (counter % 3 == 0 && i != 0) buffer.write('.');
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }
}
