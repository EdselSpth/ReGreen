import 'package:flutter/material.dart';
import '../Model/penjemputan_model.dart';
import '../service/schedule_service.dart';
import '../schedule/schedule_detail_page.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  static const Color kGreenDark = Color(0xFF558B3E);
  static const Color kCream = Color(0xFFE8EDDE);

  @override
  Widget build(BuildContext context) {
    final ScheduleService service = ScheduleService();

    return Scaffold(
      backgroundColor: kGreenDark,

      appBar: AppBar(
        backgroundColor: kGreenDark,
        foregroundColor: Colors.white,
        title: const Text(
          'Jadwal Penjemputan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: kCream,
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF558B3E).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_shipping, color: Color(0xFF558B3E)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.courierName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.alamat,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${item.tanggal.toLocal().toString().split(' ')[0]} • ${item.time}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          _statusChip(item.status),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color = Colors.grey;
    if (status == 'tersedia') color = const Color(0xFF558B3E);
    if (status == 'menunggu') color = Colors.orange;
    if (status == 'selesai') color = Colors.blueGrey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
