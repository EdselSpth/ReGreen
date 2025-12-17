import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static Future<Map<String, dynamic>?> getUserProfile(
      String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!doc.exists) return null;

    return doc.data();
  }
}
