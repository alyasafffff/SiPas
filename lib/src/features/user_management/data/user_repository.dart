import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/core/api/api_service.dart';
import 'package:lapor_app/src/core/models/user_model.dart';
import 'package:path/path.dart' as p;

class UserRepository {
  final ApiService _apiService;
  UserRepository(this._apiService);

  Future<List<User>> getAllUsers() async {
    try {
      final response = await _apiService.getAllUsers();
      if (response['status'] == 'success') {
        final List<dynamic> userListJson = response['data'];
        // Panggil User.fromJson yang sudah kita buat
        return userListJson.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUser({
    required Map<String, dynamic> userData,
    required File fotoProfil,
  }) async {
    try {
      // Langsung kirim data teks dan file. Sisanya diurus oleh ApiService.
      final response = await _apiService.addUser(userData, fotoProfil);
      if (response['status'] != 'success') {
        throw Exception(
          response['message'] ?? 'Gagal menambah user dari repository',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(Map<String, dynamic> userData) async {
    final response = await _apiService.updateUser(userData);
    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Gagal update user');
    }
  }

  Future<void> deleteUser(String userId) async {
    final response = await _apiService.deleteUser(userId);
    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Gagal menghapus user');
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(apiServiceProvider));
});
