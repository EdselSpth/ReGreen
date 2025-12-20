import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/area_model.dart';

class AreaService {
  static const String baseUrl = "http://10.0.2.2:3000/api/area";

  static Future<bool> createArea(AreaModel area) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(area.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Gagal mendaftarkan area");
    }
  }
}
