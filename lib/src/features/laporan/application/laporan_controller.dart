import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/core/models/laporan_model.dart';
import 'package:lapor_app/src/features/laporan/data/laporan_repository.dart';
import 'package:lapor_app/src/features/auth/application/auth_controller.dart';

// Controller ini akan mengelola state berupa daftar Laporan
class LaporanController extends AsyncNotifier<List<Laporan>> {
  // Method build akan menjadi method yang dipanggil untuk mengambil data awal
  @override
  FutureOr<List<Laporan>> build() {
    return _fetchLaporan();
  }

  // Fungsi privat untuk mengambil data dari repository
  Future<List<Laporan>> _fetchLaporan() async {
    final laporanRepository = ref.read(laporanRepositoryProvider);
    final laporan = await laporanRepository.getAllLaporan().timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw TimeoutException('Gagal memuat laporan. Waktu habis.');
      },
    );
    return laporan;
  }

  Future<bool> addLaporan({
    required String judul,
    required String deskripsi,
    required List<File> fotoBefore,
  }) async {
    final laporanRepository = ref.read(laporanRepositoryProvider);
    // Ambil user ID dari AuthController
    final userId = ref.read(authControllerProvider).value?.userId;
    if (userId == null) {
      throw Exception("User tidak login, tidak bisa menambah laporan");
    }

    state = const AsyncLoading();
    try {
      await laporanRepository.addLaporan(
        judul: judul,
        deskripsi: deskripsi,
        fotoBefore: fotoBefore,
        idPelapor: userId,
      );
      state = await AsyncValue.guard(() => _fetchLaporan());
      return true;
    } catch (e) {
      state = await AsyncValue.guard(() => _fetchLaporan());
      return false;
    }
  }

  Future<bool> updateLaporan({
    required String laporanId,
    required String deskripsi,
  }) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(laporanRepositoryProvider)
          .updateLaporan(laporanId: laporanId, deskripsi: deskripsi);
      // Muat ulang data untuk menampilkan perubahan
      state = await AsyncValue.guard(() => _fetchLaporan());
      return true;
    } catch (e) {
      state = await AsyncValue.guard(() => _fetchLaporan());
      return false;
    }
  }
}

// Provider untuk LaporanController
final laporanControllerProvider =
    AsyncNotifierProvider<LaporanController, List<Laporan>>(() {
      return LaporanController();
    });

// PROVIDER BARU
// Provider ini bergantung pada laporanControllerProvider dan authControllerProvider
final laporanSayaProvider = Provider<List<Laporan>>((ref) {
  // Ambil state dari semua laporan
  final semuaLaporanState = ref.watch(laporanControllerProvider);
  // Ambil state dari user yang sedang login
  final userState = ref.watch(authControllerProvider);

  // Ambil ID user yang login, jika ada
  final userId = userState.value?.userId;

  // Jika semua laporan berhasil dimuat dan user sudah login
  if (semuaLaporanState is AsyncData && userId != null) {
    // Filter daftar laporan berdasarkan idPelapor
    return semuaLaporanState.value!
        .where((laporan) => laporan.idPelapor == userId)
        .toList();
  }

  // Jika tidak, kembalikan list kosong
  return [];
});
