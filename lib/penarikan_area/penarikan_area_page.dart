import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/area_model.dart';
import '../Model/area_status.dart';
import '../Service/area_service.dart';
import '../Service/user_service.dart';
import '../navigation/edit_profile_page.dart';

class PendaftaranAreaPage extends StatefulWidget {
  const PendaftaranAreaPage({super.key});

  @override
  State<PendaftaranAreaPage> createState() => _PendaftaranAreaPageState();
}

class _PendaftaranAreaPageState extends State<PendaftaranAreaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController jalanController = TextEditingController();
  final TextEditingController kelurahanController = TextEditingController();
  final TextEditingController kecamatanController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  final TextEditingController provinsiController = TextEditingController();

  bool isLoading = true;
  bool alamatLengkap = false;
  bool dialogSudahMuncul = false;

  @override
  void initState() {
    super.initState();
    loadAlamatProfil();
  }

  @override
  void dispose() {
    jalanController.dispose();
    kelurahanController.dispose();
    kecamatanController.dispose();
    kotaController.dispose();
    provinsiController.dispose();
    super.dispose();
  }

  //load alamat profil
  Future<void> loadAlamatProfil() async {
    dialogSudahMuncul = false;

    final profile = await UserService.getCurrentUserProfile();

    final addressMap = profile != null && profile['address'] is Map
        ? profile['address'] as Map<String, dynamic>
        : {};

    final bool alamatTidakLengkap =
        profile == null ||
        (addressMap['jalan'] ?? '').toString().trim().isEmpty ||
        (addressMap['kelurahan'] ?? '').toString().trim().isEmpty ||
        (addressMap['kecamatan'] ?? '').toString().trim().isEmpty ||
        (addressMap['kota'] ?? '').toString().trim().isEmpty ||
        (addressMap['provinsi'] ?? '').toString().trim().isEmpty;
    if (alamatTidakLengkap) {
      setState(() {
        alamatLengkap = false;
        isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!dialogSudahMuncul && mounted) {
          dialogSudahMuncul = true;
          tampilkanDialogAlamat();
        }
      });
      return;
    }

    jalanController.text = addressMap['jalan'] ?? '';
    kelurahanController.text = addressMap['kelurahan'] ?? '';
    kecamatanController.text = addressMap['kecamatan'] ?? '';
    kotaController.text = addressMap['kota'] ?? '';
    provinsiController.text = addressMap['provinsi'] ?? '';

    setState(() {
      alamatLengkap = true;
      isLoading = false;
    });
  }

  //submit area
  Future<void> submitArea() async {
    setState(() => isLoading = true);

    final String uid = FirebaseAuth.instance.currentUser!.uid;

    final AreaModel area = AreaModel(
      jalan: jalanController.text,
      kelurahan: kelurahanController.text,
      kecamatan: kecamatanController.text,
      kota: kotaController.text,
      provinsi: provinsiController.text,
    );

    try {
      final String areaId = await AreaService.createArea(area);

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'areaStatus': 'pending',
        'areaId': areaId,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Area berhasil didaftarkan')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal mendaftarkan area')));
    }

    if (mounted) setState(() => isLoading = false);
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
      body: alamatLengkap ? buildForm() : _buildNeedProfile(),
    );
  }

  Widget buildForm() {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Data user tidak ditemukan'));
        }

        final Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        final AreaStatus status = areaStatusFromString(data['areaStatus']);
        final bool bolehDaftar = status == AreaStatus.notRegistered;

        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                infoStatus(status, data['rejectionReason'] as String?),
                const SizedBox(height: 16),

                fieldReadOnly('Jalan', jalanController),
                fieldReadOnly('Kelurahan', kelurahanController),
                fieldReadOnly('Kecamatan', kecamatanController),
                fieldReadOnly('Kota', kotaController),
                fieldReadOnly('Provinsi', provinsiController),

                const SizedBox(height: 24),

                if (bolehDaftar)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: submitArea,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C8E3E),
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

  Widget _buildNeedProfile() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF5C8E3E).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_off,
                size: 64,
                color: Color(0xFF5C8E3E),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Lengkapi alamat pada profil terlebih dahulu',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit_location_alt),
                label: const Text(
                  'Lengkapi Profil',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C8E3E),
                  foregroundColor: Colors.white,
                  elevation: 3,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                  await loadAlamatProfil();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void tampilkanDialogAlamat() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Alamat Belum Lengkap'),
        content: const Text('Lengkapi alamat pada profil terlebih dahulu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
              await loadAlamatProfil();
            },
            child: const Text('Ke Profil'),
          ),
        ],
      ),
    );
  }

  Widget infoStatus(AreaStatus status, String? reason) {
    if (status == AreaStatus.pending) {
      return infoBox(
        'Area sedang diverifikasi',
        Icons.hourglass_top,
        Colors.orange,
      );
    }
    if (status == AreaStatus.approved) {
      return infoBox('Area sudah disetujui', Icons.verified, Colors.green);
    }
    if (status == AreaStatus.notRegistered &&
        reason != null &&
        reason.isNotEmpty) {
      return infoBox('Pendaftaran Ditolak: $reason', Icons.cancel, Colors.red);
    }
    return const SizedBox.shrink();
  }

  Widget infoBox(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget fieldReadOnly(String label, TextEditingController controller) {
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
