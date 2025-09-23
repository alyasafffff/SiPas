import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final String? _appsScriptUrl = dotenv.env['APPS_SCRIPT_URL'];

class ApiService {
  final Dio _dio;

  ApiService(this._dio) {
    _dio.options.baseUrl = _appsScriptUrl ?? '';
    // Konfigurasi timeout untuk mencegah aplikasi hang terlalu lama
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // --- TAMBAHKAN INTERCEPTOR ---
    // Hanya aktifkan log saat dalam mode debug
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          // --- PERBARUI BAGIAN INI ---
          requestBody: true,
          responseBody: true,
          requestHeader: false, // Sembunyikan header request
          responseHeader: false, // Sembunyikan header response
          request: false, // Sembunyikan info dasar request (URL, method)
          logPrint: (o) => debugPrint(o.toString()),
        ),
      );
    }
  }

  // Metode GET: untuk mengambil data
  // Data dikirim sebagai query parameter di URL
  Future<Map<String, dynamic>> _get(Map<String, dynamic> params) async {
    if (_appsScriptUrl == null)
      throw Exception("URL Script tidak ditemukan di .env");
    try {
      final response = await _dio.get('', queryParameters: params);

      // Beberapa respons dari Apps Script bisa berupa string, perlu di-decode manual
      if (response.data is String) {
        final decodedData = jsonDecode(response.data);
        if (decodedData['status'] == 'error')
          throw Exception(decodedData['message']);
        return decodedData;
      }
      if (response.data['status'] == 'error')
        throw Exception(response.data['message']);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Gagal memuat data: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  // Metode POST: untuk mengirim, mengubah, atau menghapus data
  // Data dikirim di dalam body permintaan
  Future<Map<String, dynamic>> _post(Map<String, dynamic> body) async {
    if (_appsScriptUrl == null)
      throw Exception("URL Script tidak ditemukan di .env");
    try {
      final response = await _dio.post('', data: body);

      if (response.data is String) {
        final decodedData = jsonDecode(response.data);
        if (decodedData['status'] == 'error')
          throw Exception(decodedData['message']);
        return decodedData;
      }
      if (response.data['status'] == 'error')
        throw Exception(response.data['message']);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Gagal mengirim data: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  // --- PEMBAGIAN FUNGSI API ---

  // Menggunakan GET
  Future<Map<String, dynamic>> login(String email, String password) {
    return _get({'action': 'login', 'email': email, 'password': password});
  }

  Future<Map<String, dynamic>> getAllLaporan() {
    return _get({'action': 'getAllLaporan'});
  }

  Future<Map<String, dynamic>> getAllUsers() {
    return _get({'action': 'getAllUsers'});
  }

  // Menggunakan POST
  Future<Map<String, dynamic>> addLaporan(Map<String, dynamic> data) {
    return _post({'action': 'addLaporan', 'data': data});
  }

  Future<Map<String, dynamic>> addUser(Map<String, dynamic> data) {
    return _post({'action': 'addUser', 'data': data});
  }

  Future<Map<String, dynamic>> updateLaporan(Map<String, dynamic> data) {
    return _post({'action': 'updateLaporan', 'data': data});
  }

  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> data) {
    return _post({'action': 'updateUser', 'data': data});
  }

  Future<Map<String, dynamic>> deleteUser(String userId) {
    return _post({
      'action': 'deleteUser',
      'data': {'user_id': userId},
    });
  }
}

// Provider untuk ApiService
final apiServiceProvider = Provider<ApiService>((ref) => ApiService(Dio()));
