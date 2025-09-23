import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/core/api/api_service.dart';
import 'package:lapor_app/src/core/models/user_model.dart';

class UserRepository {
  final ApiService _apiService;
  UserRepository(this._apiService);

  Future<List<User>> getAllUsers() async {
    try {
      final response = await _apiService.getAllUsers();
      if (response['status'] == 'success') {
        final List<dynamic> userListJson = response['data'];
        return userListJson.map((json) => User(
          userId: json['user_id'],
          nama: json['nama'],
          email: json['email'],
          role: json['role'],
          jabatan: json['jabatan'],
          nomorHp: json['nomor_hp'],
          fotoProfilUrl: json['link_foto_profil'],
          tanggalDibuat: DateTime.parse(json['tanggal_dibuat']),
        )).toList();
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.updateUser(userData);
      if (response['status'] != 'success') {
        throw Exception(response['message'] ?? 'Gagal update data user');
      }
    } catch (e) {
      rethrow;
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(apiServiceProvider));
});