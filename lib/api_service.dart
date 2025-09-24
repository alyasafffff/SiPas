// lib/api_service.dart

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Ambil URL dasar dari file .env
  static final String? _apiUrl = dotenv.env['APPS_SCRIPT_URL'];

  // Fungsi untuk mengambil data (READ)
  static Future<Map<String, dynamic>> get(String action) async {
    if (_apiUrl == null) throw Exception("API_URL tidak ditemukan");

    try {
      final response = await http.get(Uri.parse("$_apiUrl?action=$action"));
      return _handleResponse(response);
    } catch (e) {
      throw Exception("Terjadi kesalahan: ${e.toString()}");
    }
  }

  // Fungsi untuk mengirim data (CREATE, UPDATE, DELETE)
  static Future<Map<String, dynamic>> post(String action, Map<String, dynamic> data) async {
    if (_apiUrl == null) throw Exception("API_URL tidak ditemukan");

    try {
      final response = await http.post(
        Uri.parse("$_apiUrl?action=$action"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception("Terjadi kesalahan: ${e.toString()}");
    }
  }

  // Helper untuk memproses response dari server
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['status'] == 'success') {
        return responseBody;
      } else {
        throw Exception("Gagal: ${responseBody['message']}");
      }
    } else {
      throw Exception("Gagal terhubung ke server: ${response.statusCode}");
    }
  }
}