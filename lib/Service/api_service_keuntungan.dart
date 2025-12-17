import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceKeuntungan {
  static const String baseUrl =
      "http://10.0.2.2:3000/api/keuntungan";

  // POST penarikan
  static Future<bool> tarikKeuntungan({
    required String firebaseUid,
    required String namaPengguna,
    required int nominal,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "firebase_uid": firebaseUid,
        "nama_pengguna": namaPengguna,
        "nominal": nominal,
      }),
    );

    return response.statusCode == 200;
  }

  // GET status penarikan user
  static Future<List<dynamic>> getStatusUser(String uid) async {
    final response =
        await http.get(Uri.parse("$baseUrl/user/$uid"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
}
