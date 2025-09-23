import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/core/models/user_model.dart';
import 'package:lapor_app/src/features/user_management/data/user_repository.dart';

class UserController extends AsyncNotifier<List<User>> {
  @override
  FutureOr<List<User>> build() {
    return _fetchUsers();
  }

  Future<List<User>> _fetchUsers() {
    return ref.read(userRepositoryProvider).getAllUsers();
  }

  Future<bool> addUser({
    required String nama,
    required String email,
    required String nomorHp,
    required String password,
    required String jabatan,
    required String role,
    // required File fotoProfil, // Untuk nanti
  }) async {
    state = const AsyncLoading();
    try {
      // Panggil repository untuk menambahkan user baru
      // await ref.read(userRepositoryProvider).addUser(...); // Ini belum kita buat, kita lewati dulu

      // Setelah berhasil, muat ulang daftar user
      state = await AsyncValue.guard(() => _fetchUsers());
      return true;
    } catch (e) {
      state = await AsyncValue.guard(() => _fetchUsers());
      return false;
    }
  }

  Future<bool> updateUser(Map<String, dynamic> userData) async {
  state = const AsyncLoading();
  try {
    await ref.read(userRepositoryProvider).updateUser(userData);
    // Muat ulang data untuk menampilkan perubahan
    state = await AsyncValue.guard(() => _fetchUsers());
    return true;
  } catch (e) {
    state = await AsyncValue.guard(() => _fetchUsers());
    return false;
  }
}
}

final userControllerProvider = AsyncNotifierProvider<UserController, List<User>>(() {
  return UserController();
});