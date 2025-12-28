import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceKeuntungan {
  static const String baseUrl = "http://10.0.2.2:3000/api/keuntungan";

  /// Fungsi untuk mengajukan penarikan baru
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

  /// Fungsi untuk mengambil riwayat status dengan Pagination
  static Future<List<dynamic>> getStatusUser(
    String firebaseUid, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url = "$baseUrl/user/$firebaseUid?page=$page&limit=$limit";
      print("DEBUG: Request URL -> $url");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Debugging untuk melihat struktur JSON asli dari backend
        print("DEBUG: Response Body -> ${response.body}");

        // Mengambil array dari dalam properti 'data'
        if (jsonResponse.containsKey('data') && jsonResponse['data'] != null) {
          List<dynamic> data = jsonResponse['data'] as List<dynamic>;
          print(
            "DEBUG: Berhasil mengambil ${data.length} data untuk page $page",
          );
          return data;
        }

        print("DEBUG: Key 'data' tidak ditemukan atau null");
        return [];
      } else {
        print("DEBUG: Server error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("DEBUG: Network error di ApiService: $e");
      return [];
    }
  }
}
