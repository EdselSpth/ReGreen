import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/area_model.dart';

class AreaService {
  static final _areaRef = FirebaseFirestore.instance.collection('areas');

  static Future<String> createArea(AreaModel area) async {
    final doc = await _areaRef.add({
      ...area.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }
}
