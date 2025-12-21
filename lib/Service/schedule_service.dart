import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ambil user login
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// simpan data penjemputan
  Future<void> submitPenjemputan({
    required String courierName,
    required String scheduleDate,
    required String scheduleTime,
    required String wasteTypes,
    required String address,
  }) async {
    final user = getCurrentUser();

    if (user == null) {
      throw Exception("User belum login");
    }

    await _firestore.collection('penjemputan').add({
      "userId": user.uid,
      "courierName": courierName,
      "scheduleDate": scheduleDate,
      "scheduleTime": scheduleTime,
      "wasteTypes": wasteTypes,
      "address": address,
      "status": "menunggu",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
