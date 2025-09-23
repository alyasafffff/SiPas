import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/core/api/api_service.dart';
import 'package:lapor_app/src/core/models/user_model.dart';

class AuthRepository {
  final ApiService _apiService;

  // 1. AuthRepository membutuhkan ApiService untuk bekerja
  AuthRepository(this._apiService);

  // Fungsi untuk login
  Future<User> login(String email, String password) async {
    try {
      // 2. Panggil fungsi login dari ApiService
      final responseData = await _apiService.login(email, password);

      // 3. Lakukan pengecekan status dari respons server
      if (responseData['status'] == 'success') {
        // 4. Jika sukses, ubah data JSON menjadi User model
        final userData = responseData['data'] as Map<String, dynamic>;
        return User(
          userId: userData['user_id'],
          nama: userData['nama'],
          email: userData['email'],
          role: userData['role'],
          jabatan: userData['jabatan'],
          nomorHp: userData['nomor_hp'],
          fotoProfilUrl: userData['link_foto_profil'],
          // Ubah string tanggal dari server menjadi objek DateTime
          tanggalDibuat: DateTime.parse(userData['tanggal_dibuat']),
        );
      } else {
        // Jika status dari server bukan 'success'
        throw Exception(responseData['message'] ?? 'Login gagal');
      }
    } catch (e) {
      // Tangkap dan teruskan error dari ApiService atau dari pengecekan di atas
      rethrow;
    }
  }

  // Di dalam class AuthRepository
Future<User> updateUser({
  required String userId,
  required String nama,
  required String email,
  required String nomorHp,
  // required File? fotoProfilBaru, // Untuk nanti saat upload gambar
}) async {
  // TODO: Logika upload foto baru ke GDrive jika ada

  final Map<String, dynamic> userData = {
    'user_id': userId,
    'nama': nama,
    'email': email,
    'nomor_hp': nomorHp,
  };

  try {
    final responseData = await _apiService.updateUser(userData);
    if (responseData['status'] == 'success') {
      // Jika sukses, server harus mengembalikan data user yang sudah terupdate
      final updatedUserData = responseData['data'] as Map<String, dynamic>;
      return User(
        userId: updatedUserData['user_id'],
        nama: updatedUserData['nama'],
        email: updatedUserData['email'],
        role: updatedUserData['role'],
        jabatan: updatedUserData['jabatan'],
        nomorHp: updatedUserData['nomor_hp'],
        fotoProfilUrl: updatedUserData['link_foto_profil'],
        tanggalDibuat: DateTime.parse(updatedUserData['tanggal_dibuat']),
      );
    } else {
      throw Exception(responseData['message'] ?? 'Gagal update profil');
    }
  } catch (e) {
    rethrow;
  }
}
}

// 5. Buat provider untuk AuthRepository
// Provider ini akan mengambil ApiService dari provider lain
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthRepository(apiService);
});