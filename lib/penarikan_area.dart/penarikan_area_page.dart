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

  final kecamatanController = TextEditingController();
  final kelurahanController = TextEditingController();
  final kotaController = TextEditingController();
  final provinsiController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserAddress();
  }

  Future<void> loadUserAddress() async {
    final user = await UserService.getCurrentUserProfile();

    if (user == null) return;

    setState(() {
      kecamatanController.text = user['kecamatan'] ?? '';
      kelurahanController.text = user['kelurahan'] ?? '';
      kotaController.text = user['kota'] ?? '';
      provinsiController.text = user['provinsi'] ?? '';
    });
  }

  Future<void> submitArea() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final area = AreaModel(
      kecamatan: kecamatanController.text,
      kelurahan: kelurahanController.text,
      kota: kotaController.text,
      provinsi: provinsiController.text,
    );

    await AreaService.createArea(area);

    setState(() => isLoading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Area berhasil didaftarkan")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pendaftaran Area")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(controller: kecamatanController),
            TextFormField(controller: kelurahanController),
            TextFormField(controller: kotaController),
            TextFormField(controller: provinsiController),
            ElevatedButton(
              onPressed: isLoading ? null : submitArea,
              child: const Text("Daftar"),
            ),
          ],
        ),
      ),
    );
  }
}
