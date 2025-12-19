import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceKeuntungan {
  // Gunakan 10.0.2.2 untuk emulator Android, atau IP asli PC jika pakai HP fisik
  static const String baseUrl = "http://10.0.2.2:3000/api/keuntungan";

  static Future<bool> tarikKeuntungan({
    required String firebaseUid,
    required String namaPengguna,
    required int nominal,
    required String rekening,
    required String metode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "firebase_uid": firebaseUid,
          "nama_pengguna": namaPengguna,
          "nominal": nominal,
          "rekening": rekening,
          "metode": metode,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Error POST Keuntungan: $e");
      return false;
    }
  }

  static Future<List<dynamic>> getStatusUser(String firebaseUid) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/user/$firebaseUid"),
      );

      print("Response Body: ${response.body}"); // Debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        
        // Mengambil array dari dalam properti 'data' sesuai struktur backend baru
        if (jsonResponse.containsKey('data') && jsonResponse['data'] != null) {
          return jsonResponse['data'] as List<dynamic>;
        }
        return [];
      } else {
        print("Server error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Network error: $e");
      return [];
    }
  }
}