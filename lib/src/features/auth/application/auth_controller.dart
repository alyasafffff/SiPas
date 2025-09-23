import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/core/models/user_model.dart';
import 'package:lapor_app/src/features/auth/data/auth_repository.dart';

// 1. Ini adalah Notifier kita. Namanya diakhiri dengan "Controller" atau "Notifier".
class AuthController extends AsyncNotifier<User?> {
  // 2. Method build() adalah tempat kita mendefinisikan state awal.
  // Di sini, kita tidak melakukan apa-apa, jadi state awalnya adalah "tidak ada user".
  @override
  FutureOr<User?> build() {
    return null;
  }

  // 3. Fungsi login yang akan dipanggil oleh UI.
  Future<bool> login(String email, String password) async {
    // Ambil repository menggunakan 'ref' yang tersedia di dalam Notifier.
    final authRepository = ref.read(authRepositoryProvider);

    // Set state menjadi loading.
    state = const AsyncLoading();

    // 4. 'state = await AsyncValue.guard(...)' adalah cara aman untuk menangani Future.
    // Ini akan secara otomatis mengatur state ke AsyncData jika berhasil,
    // atau AsyncError jika gagal.
    state = await AsyncValue.guard(() {
      return authRepository.login(email, password);
    });

    // 5. Kembalikan 'true' jika state tidak dalam kondisi error.
    return !state.hasError;
  }

  // Di dalam class AuthController
  Future<bool> updateProfil({
    required String nama,
    required String email,
    required String nomorHp,
  }) async {
    // Pastikan ada user yang sedang login
    if (state.value == null) {
      return false;
    }

    state = const AsyncLoading();
    try {
      final updatedUser = await ref
          .read(authRepositoryProvider)
          .updateUser(
            userId: state.value!.userId,
            nama: nama,
            email: email,
            nomorHp: nomorHp,
          );
      // Jika berhasil, perbarui state dengan data user yang baru
      state = AsyncData(updatedUser);
      return true;
    } catch (e) {
      // Jika gagal, kembalikan state ke data user sebelumnya
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}

// 6. Cara membuat provider untuk AsyncNotifier.
final authControllerProvider = AsyncNotifierProvider<AuthController, User?>(() {
  return AuthController();
});
