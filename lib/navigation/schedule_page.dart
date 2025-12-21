import 'package:flutter/material.dart';
import 'package:regreen/schedule/schedule_detail_page.dart';
import 'package:regreen/Model/area_model.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {

  /// 🔹 DUMMY AREA (NANTI BISA DIGANTI DARI API / USER)
  final AreaModel dummyArea = AreaModel(
    kecamatan: "Coblong",
    kelurahan: "Dago",
    kota: "Bandung",
    provinsi: "Jawa Barat",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Penjemputan")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _scheduleCard(
            courier: "Raditya",
            date: "Senin, 19 Mei 2025",
            time: "07:00 - 09:00",
            type: "Organik, Plastik",
            image: "Assets/schedule/kurir1.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ScheduleDetailPage(
                    courierName: "Raditya",
                    scheduleDate: "Senin, 19 Mei 2025",
                    scheduleTime: "07:00 - 09:00",
                    wasteTypes: "Organik, Plastik",
                    courierImage: "Assets/schedule/kurir1.png",
                    area: dummyArea, // ✅ WAJIB
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ================= CARD =================
Widget _scheduleCard({
  required String courier,
  required String date,
  required String time,
  required String type,
  required String image,
  VoidCallback? onTap,
}) {
  return Card(
    child: ListTile(
      leading: Image.asset(image, width: 50),
      title: Text(date),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time),
          Text("Kurir: $courier"),
          Text("Sampah: $type"),
        ],
      ),
      onTap: onTap,
    ),
  );
}
