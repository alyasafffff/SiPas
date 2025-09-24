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
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Konfigurasi ini tetap penting
    _dio.options.followRedirects = false;
    _dio.options.validateStatus = (status) {
      return status! < 500;
    };

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true, // Aktifkan ini untuk melihat header 'location'
          logPrint: (o) => debugPrint(o.toString()),
        ),
      );
    }
  }

  // FUNGSI UTAMA YANG BARU UNTUK MENANGANI REDIRECT SECARA MANUAL
  Future<Response> _handleRequest(Future<Response> Function() request) async {
    try {
      Response response = await request();

      // Cek jika server merespons dengan redirect (kode 301, 302, 303, 307, 308)
      if (response.isRedirect == true) {
        final location = response.headers.value('location');
        if (location != null) {
          // Lakukan permintaan kedua ke URL baru dari header 'location'
          // PENTING: Menggunakan metode dan data yang sama dari permintaan asli
          final secondResponse = await _dio.request(
            location,
            data: response.requestOptions.data, // Memastikan body POST tetap ada
            queryParameters: response.requestOptions.queryParameters, // Memastikan query GET tetap ada
            options: Options(method: response.requestOptions.method), // Memastikan metode tetap sama (POST/GET)
          );
          return secondResponse;
        }
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Fungsi untuk memproses semua respons setelah redirect ditangani
  Future<Map<String, dynamic>> _processResponse(Response response) {
    if (response.data is String) {
      final decodedData = jsonDecode(response.data);
      if (decodedData['status'] == 'error') {
        throw Exception(decodedData['message'] ?? 'Unknown error from API');
      }
      return Future.value(decodedData);
    }
    if (response.data['status'] == 'error') {
      throw Exception(response.data['message'] ?? 'Unknown error from API');
    }
    return Future.value(response.data);
  }

  // --- Metode GET dan POST sekarang menggunakan _handleRequest ---
  Future<Map<String, dynamic>> _get(Map<String, dynamic> params) async {
    if (_appsScriptUrl == null) throw Exception("URL Script tidak ditemukan di .env");
    try {
      final response = await _handleRequest(() => _dio.get('', queryParameters: params));
      return await _processResponse(response);
    } on DioException catch (e) {
      throw Exception('Gagal memuat data: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _post(Map<String, dynamic> body) async {
    if (_appsScriptUrl == null) throw Exception("URL Script tidak ditemukan di .env");
    try {
      final response = await _handleRequest(() => _dio.post('', data: body));
      return await _processResponse(response);
    } on DioException catch (e) {
      throw Exception('Gagal mengirim data: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  // --- FUNGSI API LAINNYA (TIDAK ADA PERUBAHAN) ---
  Future<Map<String, dynamic>> login(String email, String password) {
    return _get({'action': 'login', 'email': email, 'password': password});
  }

  Future<Map<String, dynamic>> getAllLaporan() {
    return _get({'action': 'getAllLaporan'});
  }

  Future<Map<String, dynamic>> getAllUsers() {
    return _get({'action': 'getAllUsers'});
  }
  // --- FUNGSI API LAINNYA (TIDAK ADA PERUBAHAN) ---


  // ... (fungsi getAllLaporan dan getAllUsers) ...

  // TAMBAHKAN FUNGSI INI KEMBALI
  Future<Map<String, dynamic>> addLaporan(Map<String, dynamic> data) {
    return _post({'action': 'addLaporan', 'data': data});
  }

  Future<Map<String, dynamic>> addUser(Map<String, dynamic> data) {
    return _post({'action': 'addUser', 'data': data});
  }
  
  // ... (sisa fungsi lainnya)



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

final apiServiceProvider = Provider<ApiService>((ref) => ApiService(Dio()));