import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:regreen/Model/penjemputan_model.dart';
import 'package:regreen/Service/schedule_service.dart';

class ScheduleDetailPage extends StatelessWidget {
  final Penjemputan penjemputan;

  const ScheduleDetailPage({super.key, required this.penjemputan});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final service = ScheduleService();

    final bolehDaftar =
        penjemputan.status == 'tersedia' || penjemputan.status == 'selesai';

    return Scaffold(
      backgroundColor: const Color(0xFFE8EDDE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF558B3E),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Penjemputan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoCard(),
            const SizedBox(height: 24),

            if (bolehDaftar)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF558B3E),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await service.daftarPenjemputan(
                      penjemputanId: penjemputan.id,
                      userId: userId,
                    );

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Berhasil mendaftar penjemputan'),
                      ),
                    );
                  },
                  child: const Text(
                    'Daftar Penjemputan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE7CC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _row(Icons.person, 'Kurir', penjemputan.courierName),
          _row(Icons.location_on, 'Alamat', penjemputan.alamat),
          _row(
            Icons.calendar_today,
            'Tanggal',
            penjemputan.tanggal.toLocal().toString().split(' ')[0],
          ),
          _row(Icons.access_time, 'Waktu', penjemputan.time),
          _row(Icons.delete, 'Jenis Sampah', penjemputan.wasteTypes),
          _row(Icons.info, 'Status', penjemputan.status.toUpperCase()),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF558B3E)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
