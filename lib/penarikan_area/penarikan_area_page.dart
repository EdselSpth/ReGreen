import 'package:flutter/material.dart';
import '../Model/area_model.dart';
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
  bool isAreaRegistered = false;

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

    final registered = await AreaService.isAreaRegistered(kecamatanCtrl.text);

    setState(() {
      allowManualInput = false;
      isAreaRegistered = registered;
      isLoading = false;
    });
  }

  Future<void> submitArea() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final area = AreaModel(
      provinsi: provinsiCtrl.text,
      kota: kotaCtrl.text,
      kecamatan: kecamatanCtrl.text,
      kelurahan: kelurahanCtrl.text,
    );

    try {
      await AreaService.createArea(area);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Area berhasil didaftarkan')),
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _inputField('Provinsi', provinsiCtrl),
              _inputField('Kota', kotaCtrl),
              _inputField('Kecamatan', kecamatanCtrl),
              _inputField('Kelurahan', kelurahanCtrl),
              const SizedBox(height: 24),

              if (!isAreaRegistered)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: submitArea,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C8E3E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Daftarkan Area'),
                  ),
                ),

              if (isAreaRegistered)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Area sudah terdaftar 🎉',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: !allowManualInput,
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
