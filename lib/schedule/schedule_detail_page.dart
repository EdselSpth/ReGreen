import 'package:flutter/material.dart';
import '../service/schedule_service.dart';
import '../Model/area_model.dart';

class ScheduleDetailPage extends StatelessWidget {
  final String courierName;
  final String scheduleDate;
  final String scheduleTime;
  final String wasteTypes;
  final String courierImage;
  final AreaModel area;

  const ScheduleDetailPage({
    super.key,
    required this.courierName,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.wasteTypes,
    required this.courierImage,
    required this.area,
  });

  @override
  Widget build(BuildContext context) {
    final ScheduleService service = ScheduleService();
    final address = service.buildAddress(area);

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Jadwal")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(courierImage, height: 150),
            const SizedBox(height: 12),

            Text("Kurir : $courierName"),
            Text("Tanggal : $scheduleDate"),
            Text("Waktu : $scheduleTime"),
            Text("Jenis Sampah : $wasteTypes"),

            const SizedBox(height: 12),
            Text("Alamat:\n$address"),

            const Spacer(),

            ElevatedButton(
              onPressed: () async {
                await service.submitPenjemputan(
                  courierName: courierName,
                  scheduleDate: scheduleDate,
                  scheduleTime: scheduleTime,
                  wasteTypes: wasteTypes,
                  area: area, // ✅ SEKARANG VALID
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Penjemputan berhasil diajukan"),
                  ), 
                );

                Navigator.pop(context);
              },
              child: const Text("Ajukan Penjemputan"),
            ),
          ],
        ),
      ),
    );
  }
}
