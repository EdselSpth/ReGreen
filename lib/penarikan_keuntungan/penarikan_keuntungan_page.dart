import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regreen/penarikan_keuntungan/status_penarikan_page.dart';
import '../Service/api_service_keuntungan.dart';
import '../../service/user_service.dart';

class PenarikanKeuntunganPage extends StatefulWidget {
  const PenarikanKeuntunganPage({super.key});

  @override
  State<PenarikanKeuntunganPage> createState() => _PenarikanKeuntunganPageState();
}

class _PenarikanKeuntunganPageState extends State<PenarikanKeuntunganPage> {
  final TextEditingController _nominalController = TextEditingController();
  int selectedNominal = 0;

  final List<int> nominalOptions = [20000, 40000, 50000, 75000, 100000, 150000, 200000, 250000, 500000, 1000000];

  String formatRupiah(int value) {
    final String number = value.toString();
    final StringBuffer buffer = StringBuffer();
    int counter = 0;
    for (int i = number.length - 1; i >= 0; i--) {
      buffer.write(number[i]);
      counter++;
      if (counter % 3 == 0 && i != 0) buffer.write('.');
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  int getNominalValue() {
    return int.tryParse(_nominalController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  void setNominal(int value) {
    setState(() {
      selectedNominal = value;
      _nominalController.text = formatRupiah(value);
    });
  }

  Future<void> _prosesPenarikan(User user) async {
    // 1. Ambil Profil & Validasi Rekening
    final profile = await UserService.getUserProfile(user.uid);
    
    if (profile == null || 
        profile['bankAccount'] == null || 
        profile['bankAccount']['accountNumber'] == null || 
        profile['bankAccount']['accountNumber'].toString().isEmpty) {
      _showAlertDialog("Data Tidak Lengkap", "Silakan lengkapi data rekening di profil Anda sebelum melakukan penarikan.");
      return;
    }

    // 2. Cek Saldo
    int currentBalance = profile['balance'] ?? 0;
    int inputNominal = getNominalValue();
    if (currentBalance < inputNominal) {
      _showAlertDialog("Saldo Kurang", "Saldo Anda tidak mencukupi untuk melakukan penarikan ini.");
      return;
    }

    // 3. Dialog Konfirmasi
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Penarikan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nominal: ${formatRupiah(inputNominal)}"),
            Text("Metode: ${profile['bankAccount']['bankName']}"),
            Text("Rekening: ${profile['bankAccount']['accountNumber']}"),
            const SizedBox(height: 10),
            const Text("Apakah data di atas sudah benar?", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF558B3E)),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Ya, Tarik", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // 4. Kirim ke API
    bool success = await ApiServiceKeuntungan.tarikKeuntungan(
      firebaseUid: user.uid,
      namaPengguna: profile['username'] ?? 'User',
      nominal: inputNominal,
      rekening: profile['bankAccount']['accountNumber'],
      metode: profile['bankAccount']['bankName'],
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Penarikan berhasil diajukan")));
      Navigator.push(context, MaterialPageRoute(builder: (_) => const StatusPenarikanPage()));
    } else {
      _showAlertDialog("Gagal", "Terjadi kesalahan saat menghubungi server.");
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFF558B3E),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 10),
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                const Expanded(child: Text("Penarikan Keuntungan", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Color(0xFFE8EDDE), borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
              child: Column(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      var userData = snapshot.data!.data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          const Text('Saldo', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold)),
                          Text(formatRupiah(userData['balance'] ?? 0), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _nominalController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() => selectedNominal = getNominalValue()),
                    decoration: InputDecoration(hintText: 'Nominal', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12, runSpacing: 12,
                    children: nominalOptions.map((nominal) {
                      final isSelected = selectedNominal == nominal;
                      return GestureDetector(
                        onTap: () => setNominal(nominal),
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 72) / 2,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: isSelected ? const Color(0xFF558B3E) : Colors.white, borderRadius: BorderRadius.circular(14)),
                          child: Text(formatRupiah(nominal), style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
                        ),
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: const Color(0xFF558B3E), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: getNominalValue() >= 20000 && user != null ? () => _prosesPenarikan(user) : null,
                      child: const Text('Tarik', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}