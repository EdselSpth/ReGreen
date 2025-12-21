import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  final provinsiCtrl = TextEditingController();
  final kotaCtrl = TextEditingController();
  final kecamatanCtrl = TextEditingController();
  final kelurahanCtrl = TextEditingController();

  bool isLoading = true;
  bool allowManualInput = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final profile = await UserService.getCurrentUserProfile();
    final address = profile?['address'];

    if (address == null) {
      setState(() {
        allowManualInput = true;
        isLoading = false;
      });
      return;
    }

    provinsiCtrl.text = address['provinsi'] ?? '';
    kotaCtrl.text = address['kota'] ?? '';
    kecamatanCtrl.text = address['kecamatan'] ?? '';
    kelurahanCtrl.text = address['kelurahan'] ?? '';

    setState(() {
      allowManualInput = false;
      isLoading = false;
    });
  }

  Future<void> _submitArea() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final area = AreaModel(
      provinsi: provinsiCtrl.text,
      kota: kotaCtrl.text,
      kecamatan: kecamatanCtrl.text,
      kelurahan: kelurahanCtrl.text,
    );

    try {
      // ⛔ AreaService TIDAK DIUBAH
      await AreaService.createArea(area);

      // 🔥 Update status user ke Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'areaStatus': 'pending',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Area berhasil didaftarkan, menunggu verifikasi'),
          ),
        );

        Navigator.pop(context, true); // 🔥 INI PENTING
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

    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('Data user tidak ditemukan')),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final areaStatus = areaStatusFromString(userData['areaStatus']);

        final bool isEditable = areaStatus == AreaStatus.notRegistered;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Pendaftaran Area'),
            backgroundColor: const Color(0xFF5C8E3E),
          ),
          backgroundColor: const Color(0xFFEFF3E8),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _statusInfo(areaStatus),
                  const SizedBox(height: 12),

                  _inputField('Provinsi', provinsiCtrl, isEditable),
                  _inputField('Kota', kotaCtrl, isEditable),
                  _inputField('Kecamatan', kecamatanCtrl, isEditable),
                  _inputField('Kelurahan', kelurahanCtrl, isEditable),

                  const SizedBox(height: 24),

                  if (isEditable)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submitArea,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C8E3E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Daftarkan Area'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
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

  Widget _inputField(
    String label,
    TextEditingController controller,
    bool enabled,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
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
