import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/penjemputan_model.dart';

class ScheduleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Penjemputan>> getPenjemputanStream() {
    return _db.collection('penjemputan').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Penjemputan.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> daftarPenjemputan({
    required String penjemputanId,
    required String userId,
  }) async {
    await _db.collection('penjemputan').doc(penjemputanId).update({
      'userId': userId,
      'status': 'menunggu',
    });
  }

  Future<void> autoCreateScheduleForApprovedUser({
    required String userId,
  }) async {
    final userRef = _db.collection('users').doc(userId);
    final userSnap = await userRef.get();

    if (!userSnap.exists) return;

    final userData = userSnap.data()!;
    if (userData['areaStatus'] != 'approved') return;

    final Map<String, dynamic>? alamat =
        userData['address'] as Map<String, dynamic>?;

    final String? areaId = userData['areaId'];

    if (alamat == null || areaId == null) return;

    final now = DateTime.now();
    final dateString =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final existing = await _db
        .collection('penjemputan')
        .where('areaId', isEqualTo: areaId)
        .where('date', isEqualTo: dateString)
        .get();

    print('Dokumen existing: ${existing.docs.length}');

    if (existing.docs.isNotEmpty) {
      //debugging
      print('Jadwal untuk daerah ini sudah ada, tidak dibuat lagi');
      return;
    }
    try {
      await _db.collection('penjemputan').add({
        'areaId': areaId,
        'alamat': alamat,
        'courier_name': 'Ajang',
        'date': dateString,
        'time': '15:00-17:00',
        'status': 'tersedia',
        'waste_type': 'campuran',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Berhasil buat jadwal');
    } catch (e) {
      print('Gagal buat jadwal: $e');
    }
  }
}
