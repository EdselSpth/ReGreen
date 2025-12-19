import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceVideo {
  static const String baseUrl = "http://10.0.2.2:3000/api/video";

  static Future<bool> createVideo({
    required String namaVideo,
    required String linkYoutube,
    String? deskripsi,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "nama_video": namaVideo,
        "link_youtube": linkYoutube,
        "deskripsi": deskripsi,
      }),
    );

    return response.statusCode == 201;
  }

  static Future<List<dynamic>> getAllVideo() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['data']; // sesuai response.success
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getVideoById(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$id"),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['data'];
    } else {
      return null;
    }
  }

  static Future<bool> updateVideo({
    required int id,
    required String namaVideo,
    required String linkYoutube,
    String? deskripsi,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "nama_video": namaVideo,
        "link_youtube": linkYoutube,
        "deskripsi": deskripsi,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> deleteVideo(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$id"),
    );

    return response.statusCode == 200;
  }
}
