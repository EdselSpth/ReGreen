import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/penjemputan_model.dart';
import '../Service/schedule_service.dart';
import '../schedule/schedule_detail_page.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  static const Color kGreenDark = Color(0xFF558B3E);
  static const Color kCream = Color(0xFFE8EDDE);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final ScheduleService service = ScheduleService();

  StreamSubscription<DocumentSnapshot>? _userSub;
  bool _autoScheduleTriggered = false;
  String? _userAreaId;
  // ===============================
  // 🔥 AUTOMATISASI (AMAN & STABIL)
  // ===============================
  @override
  void initState() {
    super.initState();
    _initAutoScheduleListener();
  }

  void _initAutoScheduleListener() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _userSub = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
          if (!mounted) return;
          if (!snapshot.exists) return;
          if (_autoScheduleTriggered) return;

          final data = snapshot.data() as Map<String, dynamic>;
          final status = data['areaStatus']?.toString().toLowerCase();

          if (status != 'approved') return;
          _autoScheduleTriggered = true;

          _userAreaId = data['areaId']?.toString();

          service.autoCreateScheduleForApprovedUser(userId: user.uid);
        });
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }

  // ===============================
  // UI (TIDAK DIUBAH)
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SchedulePage.kGreenDark,
      appBar: AppBar(
        backgroundColor: SchedulePage.kGreenDark,
        foregroundColor: Colors.white,
        title: const Text(
          'Jadwal Penjemputan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: SchedulePage.kCream,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: StreamBuilder<List<Penjemputan>>(
            stream: service.getPenjemputanStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final list = snapshot.data ?? [];
              // 🔹 Sort supaya jadwal area user berada di atas
              if (_userAreaId != null) {
                list.sort((a, b) {
                  if (a.areaId == _userAreaId && b.areaId != _userAreaId)
                    return -1;
                  if (a.areaId != _userAreaId && b.areaId == _userAreaId)
                    return 1;
                  return 0;
                });
              }
              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada jadwal penjemputan',
                    style: TextStyle(color: Colors.black54),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScheduleDetailPage(penjemputan: item),
                        ),
                      );
                    },
                    child: _ScheduleCard(item: item),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// ===============================
// CARD (TIDAK DIUBAH)
// ===============================
class _ScheduleCard extends StatelessWidget {
  final Penjemputan item;
  const _ScheduleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE7CC),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping, color: Color(0xFF558B3E)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.courierName.isEmpty
                      ? 'Menunggu Kurir'
                      : item.courierName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(item.alamat),
                Text('${item.time} • ${item.status}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
