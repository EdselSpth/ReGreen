import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Service/area_service.dart';
import '../Service/user_service.dart';
import '../penarikan_area/penarikan_area_page.dart';
import '../penarikan_keuntungan/penarikan_keuntungan_page.dart';
import '../penarikan_keuntungan/status_penarikan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = 'ReGreeners';
  String? photoBase64;

  bool isAreaRegistered = false;
  bool hasValidAddress = false;
  bool loadingArea = true;
  String? userKecamatan;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    checkUserArea();
  }

  Future<void> fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      setState(() {
        userName = doc['username'] ?? 'ReGreeners';
        photoBase64 = doc['photoBase64'];
      });
    }
  }

  Future<void> checkUserArea() async {
    final profile = await UserService.getCurrentUserProfile();

    final address = profile?['address'];
    if (address == null || address['kecamatan'] == null) {
      setState(() {
        hasValidAddress = false;
        loadingArea = false;
      });
      return;
    }

    userKecamatan = address['kecamatan'];
    hasValidAddress = true;

    final registered = await AreaService.isAreaRegistered(userKecamatan!);

    setState(() {
      isAreaRegistered = registered;
      loadingArea = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider avatar =
        (photoBase64 != null && photoBase64!.isNotEmpty)
        ? MemoryImage(base64Decode(photoBase64!))
        : const AssetImage('Assets/profile1.jpeg');

    return Scaffold(
      backgroundColor: const Color(0xFF558B3E),
      body: SafeArea(
        child: Column(
          children: [
            _header(avatar),
            Expanded(child: _content(context)),
          ],
        ),
      ),
    );
  }

  Widget _header(ImageProvider avatar) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 45, 30, 45),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: avatar),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang, $userName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Mau Setor Apa Hari Ini?',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE8EDDE),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _saldoCard(),
            const SizedBox(height: 12),
            _statusPenarikan(context),
            const SizedBox(height: 18),
            _areaSection(context),
          ],
        ),
      ),
    );
  }

  Widget _saldoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE7CC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SALDO', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'Rp. 200.000.000,00',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusPenarikan(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const StatusPenarikanPage()),
      ),
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
            Expanded(child: Text('Cek Status Penarikan')),
            Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _areaSection(BuildContext context) {
    if (loadingArea) {
      return const Padding(
        padding: EdgeInsets.only(top: 16),
        child: CircularProgressIndicator(),
      );
    }

    if (!hasValidAddress) {
      return _infoBox(
        'Lengkapi alamatmu terlebih dahulu untuk melihat jadwal pengambilan',
      );
    }

    if (!isAreaRegistered) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _infoBox('Areamu belum terdaftar di area pengambilan'),
          const SizedBox(height: 12),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF558B3E),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PendaftaranAreaPage()),
              );

              if (result == true) {
                setState(() {
                  loadingArea = true;
                });
                await checkUserArea();
              }
            },
            child: const Text(
              'Daftar Sekarang!!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    return _infoBox(
      'Areamu sudah terdaftar 🎉\nKamu bisa langsung melakukan penjemputan.',
    );
  }

  Widget _infoBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE7CC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
