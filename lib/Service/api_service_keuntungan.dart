import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceKeuntungan {
  static const String baseUrl ="http://10.0.2.2:3000/api/keuntungan";

  static Future<bool> tarikKeuntungan({
    required String firebaseUid,
    required String namaPengguna,
    required int nominal,
    required String rekening,
    required String metode,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "firebase_uid": firebaseUid,
        "nama_pengguna": namaPengguna,
        "nominal": nominal,
        "rekening": rekening,
        "metode": metode,
      }),
    );

    return response.statusCode == 201;
  }

  static Future<List<dynamic>> getStatusUser(
      String firebaseUid) async {
    final response = await http.get(
      Uri.parse("$baseUrl/user/$firebaseUid"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }
}
