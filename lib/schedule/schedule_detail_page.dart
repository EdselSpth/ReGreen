import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/penjemputan_model.dart';
import '../service/schedule_service.dart';

class ScheduleDetailPage extends StatelessWidget {
  final Penjemputan penjemputan;

  const ScheduleDetailPage({super.key, required this.penjemputan});

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final ScheduleService service = ScheduleService();

    final bool bolehDaftar =
        penjemputan.status == 'tersedia' || penjemputan.status == 'selesai';

    Color statusColor;
    switch (penjemputan.status.toLowerCase()) {
      case 'tersedia':
        statusColor = Colors.green;
        break;
      case 'selesai':
        statusColor = Colors.blue;
        break;
      case 'dibatalkan':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8EDDE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF558B3E),
        foregroundColor: Colors.white,
        title: const Text(
          'Detail Penjemputan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoCard(penjemputan: penjemputan, statusColor: statusColor),
            const SizedBox(height: 32),
            if (bolehDaftar)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF558B3E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
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
}

class _InfoCard extends StatelessWidget {
  final Penjemputan penjemputan;
  final Color statusColor;

  const _InfoCard({required this.penjemputan, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE7CC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _row(Icons.person, 'Kurir', penjemputan.courierName),
          const SizedBox(height: 8),
          _row(Icons.location_on, 'Alamat', penjemputan.alamat),
          const SizedBox(height: 8),
          _row(
            Icons.calendar_today,
            'Tanggal',
            penjemputan.tanggal.toLocal().toString().split(' ')[0],
          ),
          const SizedBox(height: 8),
          _row(Icons.access_time, 'Waktu', penjemputan.time),
          const SizedBox(height: 8),
          _row(Icons.delete, 'Jenis Sampah', penjemputan.wasteTypes),
          const SizedBox(height: 16),
          // Status
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                penjemputan.status.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: const Color(0xFF558B3E)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
