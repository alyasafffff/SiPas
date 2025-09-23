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
    return ref.read(userRepositoryProvider).getAllUsers().timeout(
      const Duration(seconds: 20),
      onTimeout: () => throw TimeoutException('Gagal memuat daftar user. Waktu habis.'),
    );
  }

  Future<bool> addUser({
    required Map<String, dynamic> userData,
    required File fotoProfil,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(userRepositoryProvider).addUser(
        userData: userData,
        fotoProfil: fotoProfil,
      );
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
      state = await AsyncValue.guard(() => _fetchUsers());
      return true;
    } catch (e) {
      state = await AsyncValue.guard(() => _fetchUsers());
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    state = const AsyncLoading();
    try {
      await ref.read(userRepositoryProvider).deleteUser(userId);
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