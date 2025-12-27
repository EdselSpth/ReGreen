import 'package:cloud_firestore/cloud_firestore.dart';

class Penjemputan {
  final String id;
  final String alamat;
  final String courierName;
  final DateTime tanggal;
  final String status;
  final String time;
  final String wasteTypes;
  final String? userId;

  Penjemputan({
    required this.id,
    required this.alamat,
    required this.courierName,
    required this.tanggal,
    required this.status,
    required this.time,
    required this.wasteTypes,
    required this.userId,
  });

  factory Penjemputan.fromMap(Map<String, dynamic> data, String documentId) {
    DateTime parsedDate;

    if (data['date'] is Timestamp) {
      parsedDate = (data['date'] as Timestamp).toDate();
    } else {
      parsedDate = DateTime.now();
    }

    return Penjemputan(
      id: documentId,
      alamat: data['alamat'] ?? '',
      courierName: data['courier_name'] ?? data['courierName'] ?? '',
      tanggal: parsedDate,
      status: data['status'] ?? '',
      time: data['time'] ?? '',
      wasteTypes: data['wasteTypes'] ?? '',
      userId: data['userId'],
    );
  }
}
