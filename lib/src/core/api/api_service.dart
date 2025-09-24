import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

final String? _appsScriptUrl = dotenv.env['APPS_SCRIPT_URL'];

// --- INTERCEPTOR FINAL UNTUK MENANGANI SEMUA JENIS REDIRECT ---
class GoogleAppsScriptRedirectInterceptor extends Interceptor {
  final Dio dio;
  GoogleAppsScriptRedirectInterceptor(this.dio);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Tangani redirect untuk request GET (seperti login)
    if (response.statusCode == 302) {
      try {
        final newUrl = response.headers['location']?.first;
        if (newUrl != null) {
          debugPrint("Redirecting GET request to: $newUrl");
          // Lakukan request GET baru ke URL redirect
          final newResponse = await dio.get(newUrl);
          return handler.resolve(
            newResponse,
          ); // Selesaikan dengan response baru
        }
      } catch (e) {
        return handler.reject(
          DioException(requestOptions: response.requestOptions, error: e),
        );
      }
    }
    // Jika bukan redirect, lanjutkan seperti biasa
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Tangani redirect untuk request POST (seperti add user/laporan)
    if (err.response?.statusCode == 302) {
      try {
        final options = err.response!.requestOptions;
        final newUrl = err.response!.headers['location']?.first;

        if (newUrl != null) {
          debugPrint("Redirecting POST request to: $newUrl");
          // Kirim ulang request POST ke URL baru dengan data yang sama
          final response = await dio.post(newUrl, data: options.data);
          return handler.resolve(response); // Selesaikan dengan response baru
        }
      } catch (e) {
        return handler.next(err);
      }
    }
    // Jika bukan error 302, lanjutkan seperti biasa
    return handler.next(err);
  }
}
// ----------------------------------------------------------------

class ApiService {
  final Dio _dio;

  ApiService(this._dio) {
    _dio.options.baseUrl = _appsScriptUrl ?? '';
    _dio.options.connectTimeout = const Duration(seconds: 90);
    _dio.options.receiveTimeout = const Duration(seconds: 90);

    // Konfigurasi ini PENTING untuk interceptor bisa bekerja
    _dio.options.followRedirects =
        false; // JANGAN ikuti redirect secara otomatis
    _dio.options.validateStatus = (status) {
      // Anggap 302 sebagai error agar ditangkap oleh onError
      return status != null && status < 300 || status == 302;
    };

    // Tambahkan interceptor baru kita
    _dio.interceptors.add(GoogleAppsScriptRedirectInterceptor(_dio));

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (o) => debugPrint(o.toString()),
        ),
      );
    }
  }

  // Sisa file ini SAMA PERSIS, tidak ada yang perlu diubah

  Future<Map<String, dynamic>> _get(Map<String, dynamic> params) async {
    if (_appsScriptUrl == null)
      throw Exception("URL Script tidak ditemukan di .env");
    try {
      final response = await _dio.get('', queryParameters: params);
      if (response.data is String) return jsonDecode(response.data);
      return response.data;
    } on DioException catch (e) {
      // Tambahkan detail error untuk debugging
      final errorDetail = e.response?.data ?? e.message;
      throw Exception('Gagal memuat data: $errorDetail');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _postJson(Map<String, dynamic> body) async {
    if (_appsScriptUrl == null)
      throw Exception("URL Script tidak ditemukan di .env");
    try {
      final response = await _dio.post('', data: body);
      if (response.data is String) return jsonDecode(response.data);
      return response.data;
    } on DioException catch (e) {
      final errorDetail = e.response?.data ?? e.message;
      throw Exception('Gagal mengirim data JSON: $errorDetail');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _postFormData({
    required Map<String, dynamic> data,
    Map<String, File> files = const {},
    Map<String, List<File>> listFiles = const {},
  }) async {
    if (_appsScriptUrl == null)
      throw Exception("URL Script tidak ditemukan di .env");
    try {
      final Map<String, dynamic> formDataMap = data.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      for (var entry in files.entries) {
        File file = entry.value;
        formDataMap[entry.key] = await MultipartFile.fromFile(
          file.path,
          filename: p.basename(file.path),
        );
        formDataMap['fileName'] = p.basename(file.path);
      }
      for (var entry in listFiles.entries) {
        for (int i = 0; i < entry.value.length; i++) {
          File file = entry.value[i];
          String fieldName = '${entry.key}_$i';
          String fileNameField = 'fileName_$fieldName';
          formDataMap[fieldName] = await MultipartFile.fromFile(
            file.path,
            filename: p.basename(file.path),
          );
          formDataMap[fileNameField] = p.basename(file.path);
        }
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post('', data: formData);
      if (response.data is String) return jsonDecode(response.data);
      return response.data;
    } on DioException catch (e) {
      final errorDetail = e.response?.data ?? e.message;
      throw Exception('Gagal mengirim form-data: $errorDetail');
    } catch (e) {
      rethrow;
    }
  }

  // --- Panggilan API (TIDAK ADA PERUBAHAN) ---
  Future<Map<String, dynamic>> login(String email, String password) =>
      _get({'action': 'login', 'email': email, 'password': password});
  Future<Map<String, dynamic>> getAllLaporan() =>
      _get({'action': 'getAllLaporan'});
  Future<Map<String, dynamic>> getAllUsers() => _get({'action': 'getAllUsers'});
  Future<Map<String, dynamic>> addUser(
    Map<String, dynamic> data,
    File fotoProfil,
  ) => _postFormData(
    data: {'action': 'addUser', ...data},
    files: {'foto_profil': fotoProfil},
  );
  Future<Map<String, dynamic>> addLaporan(
    Map<String, dynamic> data,
    List<File> fotoBefore,
  ) => _postFormData(
    data: {'action': 'addLaporan', ...data},
    listFiles: {'foto_before': fotoBefore},
  );
  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> data) =>
      _postJson({'action': 'updateUser', 'data': data});
  Future<Map<String, dynamic>> updateLaporan(Map<String, dynamic> data) =>
      _postJson({'action': 'updateLaporan', 'data': data});
  Future<Map<String, dynamic>> deleteUser(String userId) => _postJson({
    'action': 'deleteUser',
    'data': {'user_id': userId},
  });
}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService(Dio()));
