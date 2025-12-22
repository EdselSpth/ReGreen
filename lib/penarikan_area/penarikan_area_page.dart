import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:regreen/navigation/edit_profile_page.dart';
import '../Model/area_model.dart';
import '../Model/area_status.dart';
import '../Service/area_service.dart';
import '../Service/user_service.dart';

class PendaftaranAreaPage extends StatefulWidget {
  const PendaftaranAreaPage({super.key});

  @override
  State<PendaftaranAreaPage> createState() => _PendaftaranAreaPageState();
}

class _PendaftaranAreaPageState extends State<PendaftaranAreaPage> {
  final _formKey = GlobalKey<FormState>();

  final jalanCtrl = TextEditingController();
  final kelurahanCtrl = TextEditingController();
  final kecamatanCtrl = TextEditingController();
  final kotaCtrl = TextEditingController();
  final provinsiCtrl = TextEditingController();

  bool isLoading = true;
  bool hasAddressProfile = false;

  @override
  void initState() {
    super.initState();
    _loadProfileAddress();
  }

  Future<void> _loadProfileAddress() async {
    final profile = await UserService.getCurrentUserProfile();
    final address = profile?['address'];

    if (address == null) {
      setState(() {
        hasAddressProfile = false;
        isLoading = false;
      });
      return;
    }

    jalanCtrl.text = address['jalan'] ?? '';
    kelurahanCtrl.text = address['kelurahan'] ?? '';
    kecamatanCtrl.text = address['kecamatan'] ?? '';
    kotaCtrl.text = address['kota'] ?? '';
    provinsiCtrl.text = address['provinsi'] ?? '';

    setState(() {
      hasAddressProfile = true;
      isLoading = false;
    });
  }

  Future<void> _submitArea() async {
    setState(() => isLoading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final area = AreaModel(
      jalan: jalanCtrl.text,
      kelurahan: kelurahanCtrl.text,
      kecamatan: kecamatanCtrl.text,
      kota: kotaCtrl.text,
      provinsi: provinsiCtrl.text,
    );

    try {
      final areaId = await AreaService.createArea(area);

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'areaStatus': 'pending',
        'areaId': areaId,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Area berhasil didaftarkan, menunggu verifikasi'),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal mendaftarkan area')));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Area'),
        backgroundColor: const Color(0xFF5C8E3E),
      ),
      backgroundColor: const Color(0xFFEFF3E8),
      body: hasAddressProfile
          ? _buildForm(context)
          : _buildNeedProfileAddress(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Data user tidak ditemukan'));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final status = areaStatusFromString(data['areaStatus']);
        final canSubmit = status == AreaStatus.notRegistered;

        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _statusInfo(status),
                const SizedBox(height: 16),

                _readOnlyField('Nama Jalan', jalanCtrl),
                _readOnlyField('Kelurahan', kelurahanCtrl),
                _readOnlyField('Kecamatan', kecamatanCtrl),
                _readOnlyField('Kota', kotaCtrl),
                _readOnlyField('Provinsi', provinsiCtrl),

                const SizedBox(height: 24),

                if (canSubmit)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submitArea,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C8E3E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Daftarkan Area',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNeedProfileAddress(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 72, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Masukkan alamat di profil terlebih dahulu',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C8E3E),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
              },
              child: const Text('Lengkapi Profil'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusInfo(AreaStatus status) {
    switch (status) {
      case AreaStatus.pending:
        return _infoBox(
          'Area sedang diverifikasi.\nData tidak dapat diubah.',
          Icons.hourglass_top,
        );
      case AreaStatus.approved:
        return _infoBox(
          'Area sudah disetujui.\nPendaftaran tidak dapat diubah.',
          Icons.verified,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _infoBox(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _readOnlyField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF5F7F2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
