import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceArtikel {
  static const String baseUrl = "http://10.0.2.2:3000/api/artikel";

  /// CREATE ARTIKEL
  static Future<bool> createArtikel({
    required String namaArtikel,
    required String filePdf,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "nama_artikel": namaArtikel,
          "file_pdf": filePdf,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print("Create artikel failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error create artikel: $e");
      return false;
    }
  }

  /// GET ALL ARTIKEL
  static Future<List<dynamic>> getAllArtikel() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        return [];
      }
    } catch (e) {
      print("Error get all artikel: $e");
      return [];
    }
  }

  /// GET ARTIKEL BY ID
  static Future<Map<String, dynamic>?> getArtikelById(int id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$id"));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        return null;
      }
    } catch (e) {
      print("Error get artikel by id: $e");
      return null;
    }
  }

  /// UPDATE ARTIKEL
  static Future<bool> updateArtikel({
    required int id,
    required String namaArtikel,
    required String filePdf,
  }) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "nama_artikel": namaArtikel,
          "file_pdf": filePdf,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error update artikel: $e");
      return false;
    }
  }

  /// DELETE ARTIKEL
  static Future<bool> deleteArtikel(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      return response.statusCode == 200;
    } catch (e) {
      print("Error delete artikel: $e");
      return false;
    }
  }
}
