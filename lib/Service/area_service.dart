import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/area_model.dart';

class AreaService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static Future<void> createArea(AreaModel area) async {
    final response = await http.post(
      Uri.parse('$baseUrl/area'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(area.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Gagal mendaftarkan area');
    }
  }

  static Future<bool> isAreaRegistered(String kecamatan) async {
    final response = await http.get(
      Uri.parse('$baseUrl/area?kecamatan=$kecamatan'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data is List && data.isNotEmpty;
    }

    return false;
  }
}
