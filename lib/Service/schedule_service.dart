import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/area_model.dart';

class ScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String buildAddress(AreaModel area) {
    return "${area.kelurahan}, ${area.kecamatan}, "
        "${area.kota}, ${area.provinsi}";
  }

  Future<void> submitPenjemputan({
    required String courierName,
    required String scheduleDate,
    required String scheduleTime,
    required String wasteTypes,
    required AreaModel area,
  }) async {
    final jadwalQuery = await _firestore
        .collection('jadwal')
        .where('courierName', isEqualTo: courierName)
        .where('date', isEqualTo: scheduleDate)
        .where('time', isEqualTo: scheduleTime)
        .limit(1)
        .get();

    if (jadwalQuery.docs.isEmpty) {
      throw Exception("Jadwal tidak ditemukan");
    }

    final jadwalDoc = jadwalQuery.docs.first;
    final status = jadwalDoc['status'];

    if (status != 'tersedia') {
      throw Exception("Jadwal sudah diambil");
    }

    // Simpan pengajuan
    await _firestore.collection('penjemputan').add({
      'courierName': courierName,
      'date': scheduleDate,
      'time': scheduleTime,
      'wasteTypes': wasteTypes,
      'alamat': buildAddress(area),
      'status': 'menunggu',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update status jadwal
    await jadwalDoc.reference.update({
      'status': 'diambil',
    });
  }
}
