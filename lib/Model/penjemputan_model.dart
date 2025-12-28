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
  final String? areaId;

  Penjemputan({
    required this.id,
    required this.alamat,
    required this.courierName,
    required this.tanggal,
    required this.status,
    required this.time,
    required this.wasteTypes,
    required this.userId,
    required this.areaId,
  });

  factory Penjemputan.fromMap(Map<String, dynamic> data, String documentId) {
    DateTime parsedDate;

    if (data['date'] is Timestamp) {
      parsedDate = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is String) {
      try {
        parsedDate = DateTime.parse(data['date']);
      } catch (e) {
        parsedDate = DateTime.now();
      }
    } else {
      parsedDate = DateTime.now();
    }
    String alamatString = '';
    final alamatData = data['alamat'];
    if (alamatData != null && alamatData is Map<String, dynamic>) {
      final jalan = alamatData['jalan'] ?? '';
      final kelurahan = alamatData['kelurahan'] ?? '';
      final kecamatan = alamatData['kecamatan'] ?? '';
      final kota = alamatData['kota'] ?? '';
      final provinsi = alamatData['provinsi'] ?? '';

      alamatString = [
        jalan,
        kelurahan,
        kecamatan,
        kota,
        provinsi,
      ].where((s) => s.isNotEmpty).join(', ');
    } else if (alamatData is String) {
      alamatString = alamatData;
    }
    return Penjemputan(
      id: documentId,
      alamat: alamatString,
      courierName: data['courier_name'] ?? data['courierName'] ?? '',
      tanggal: parsedDate,
      status: data['status'] ?? '',
      time: data['time'] ?? '',
      wasteTypes: data['waste_type'] ?? data['wasteTypes'] ?? ' ',
      userId: data['userId'],
      areaId: data['areaId'],
    );
  }
}
