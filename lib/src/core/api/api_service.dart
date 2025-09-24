// Lokasi: lib/src/core/api/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

final String? _appsScriptUrl = dotenv.env['APPS_SCRIPT_URL'];

class ApiService {
  final Dio _dio;

  ApiService(this._dio) {
    _dio.options.baseUrl = _appsScriptUrl ?? '';
    _dio.options.connectTimeout = const Duration(seconds: 90);
    _dio.options.receiveTimeout = const Duration(seconds: 90);

    // --- PERBAIKAN UTAMA DAN TERAKHIR ADA DI SINI ---
    // 1. Perintahkan Dio untuk selalu mengikuti pengalihan (redirects).
    _dio.options.followRedirects = true;
    _dio.options.maxRedirects = 5; // Batas pengalihan

    // 2. Anggap status '302 Moved Temporarily' sebagai respons yang valid,
    //    bukan error, agar Dio mau mengikuti alamat baru dari Google.
    _dio.options.validateStatus = (status) {
      return status != null && status < 500; // Terima semua status di bawah 500
    };
    // --------------------------------------------------

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint(o.toString()),
      ));
    }
  }

  // Metode GET tidak berubah
  Future<Map<String, dynamic>> _get(Map<String, dynamic> params) async {
    if (_appsScriptUrl == null) throw Exception("URL Script tidak ditemukan di .env");
    try {
      final response = await _dio.get('', queryParameters: params);
      if (response.data is String) return jsonDecode(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Gagal memuat data: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  // Metode POST JSON (untuk update/delete) tidak berubah
  Future<Map<String, dynamic>> _postJson(Map<String, dynamic> body) async {
    if (_appsScriptUrl == null) throw Exception("URL Script tidak ditemukan di .env");
    try {
      final response = await _dio.post('', data: body);
      if (response.data is String) return jsonDecode(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Gagal mengirim data: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  // Metode POST FormData tidak berubah
  Future<Map<String, dynamic>> _postFormData({
    required Map<String, dynamic> data,
    Map<String, File> files = const {},
    Map<String, List<File>> listFiles = const {},
  }) async {
    if (_appsScriptUrl == null) throw Exception("URL Script tidak ditemukan di .env");
    try {
      final Map<String, dynamic> formDataMap = data.map((key, value) => MapEntry(key, value.toString()));
      for (var entry in files.entries) {
        File file = entry.value;
        formDataMap[entry.key] = await MultipartFile.fromFile(file.path, filename: p.basename(file.path));
        formDataMap['fileName'] = p.basename(file.path);
      }
      for (var entry in listFiles.entries) {
        for (int i = 0; i < entry.value.length; i++) {
          File file = entry.value[i];
          String fieldName = '${entry.key}_$i';
          String fileNameField = 'fileName_$fieldName';
          formDataMap[fieldName] = await MultipartFile.fromFile(file.path, filename: p.basename(file.path));
          formDataMap[fileNameField] = p.basename(file.path);
        }
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post('', data: formData);
      if (response.data is String) return jsonDecode(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception('DioException: Gagal mengirim form-data: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  // Panggilan API tidak ada perubahan
  Future<Map<String, dynamic>> login(String email, String password) => _get({'action': 'login', 'email': email, 'password': password});
  Future<Map<String, dynamic>> getAllLaporan() => _get({'action': 'getAllLaporan'});
  Future<Map<String, dynamic>> getAllUsers() => _get({'action': 'getAllUsers'});
  Future<Map<String, dynamic>> addUser(Map<String, dynamic> data, File fotoProfil) => _postFormData(data: {'action': 'addUser', ...data}, files: {'foto_profil': fotoProfil});
  Future<Map<String, dynamic>> addLaporan(Map<String, dynamic> data, List<File> fotoBefore) => _postFormData(data: {'action': 'addLaporan', ...data}, listFiles: {'foto_before': fotoBefore});
  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> data) => _postJson({'action': 'updateUser', 'data': data});
  Future<Map<String, dynamic>> updateLaporan(Map<String, dynamic> data) => _postJson({'action': 'updateLaporan', 'data': data});
  Future<Map<String, dynamic>> deleteUser(String userId) => _postJson({'action': 'deleteUser', 'data': {'user_id': userId}});
}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService(Dio()));