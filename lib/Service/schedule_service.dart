import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regreen/Model/penjemputan_model.dart';

class ScheduleService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Penjemputan>> getPenjemputanStream() {
    return _db
        .collection('penjemputan')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Penjemputan.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// USER DAFTAR
  Future<void> daftarPenjemputan({
    required String penjemputanId,
    required String userId,
  }) async {
    final ref = _db.collection('penjemputan').doc(penjemputanId);

    await ref.update({
      'userId': userId,
      'status': 'menunggu',
    });
  }
}
