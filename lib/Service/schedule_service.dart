import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/area_model.dart';

class ScheduleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ✅ WAJIB ADA
  String buildAddress(AreaModel area) {
    return
        "Kecamatan ${area.kecamatan}, "
        "Kelurahan ${area.kelurahan}, "
        "Kota ${area.kota}, "
        "Provinsi ${area.provinsi}";
  }

  Future<void> submitPenjemputan({
    required String courierName,
    required String scheduleDate,
    required String scheduleTime,
    required String wasteTypes,
    required AreaModel area,
  }) async {
    final user = getCurrentUser();

    if (user == null) {
      throw Exception("User belum login");
    }

    final address = buildAddress(area);

    await _firestore.collection('penjemputan').add({
      "userId": user.uid,
      "courierName": courierName,
      "scheduleDate": scheduleDate,
      "scheduleTime": scheduleTime,
      "wasteTypes": wasteTypes,
      "address": address,
      "area": area.toJson(),
      "status": "menunggu",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
