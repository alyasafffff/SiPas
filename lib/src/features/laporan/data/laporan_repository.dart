import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:lapor_app/src/core/api/api_service.dart';
import 'package:lapor_app/src/core/models/laporan_model.dart';

class LaporanRepository {
  final ApiService _apiService;

  LaporanRepository(this._apiService);

  Future<List<Laporan>> getAllLaporan() async {
    try {
      final responseData = await _apiService.getAllLaporan();

      if (responseData['status'] == 'success') {
        // Ambil list data mentah dari JSON
        final List<dynamic> laporanListJson = responseData['data'];

        // Ubah setiap item di list menjadi objek Laporan
        return laporanListJson
            .map(
              (json) => Laporan(
                laporanId: json['laporan_id'],
                judul: json['judul'],
                deskripsi: json['deskripsi'],
                idPelapor: json['id_pelapor'],
                status: json['status'],
                tanggalDibuat: DateTime.parse(json['tanggal_dibuat']),
                // Cek jika tanggal selesai tidak null sebelum di-parse
                tanggalSelesai: json['tanggal_selesai'] != null
                    ? DateTime.parse(json['tanggal_selesai'])
                    : null,
                linkFotoBefore: json['link_foto_before'],
                linkFotoAfter: json['link_foto_after'],
              ),
            )
            .toList();
      } else {
        throw Exception(
          responseData['message'] ?? 'Gagal mengambil data laporan',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addLaporan({
    required String judul,
    required String deskripsi,
    required List<File> fotoBefore,
    required String idPelapor,
  }) async {
    try {
      final Map<String, dynamic> laporanData = {
        'judul': judul,
        'deskripsi': deskripsi,
        'id_pelapor': idPelapor,
      };
      // Langsung kirim data dan list file
      final responseData = await _apiService.addLaporan(
        laporanData,
        fotoBefore,
      );
      if (responseData['status'] != 'success') {
        throw Exception(responseData['message'] ?? 'Gagal menambah laporan');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateLaporan({
    required String laporanId,
    required String deskripsi,
    // Nanti akan ada List<File> fotoAfterBaru, dll.
  }) async {
    final Map<String, dynamic> laporanData = {
      'laporan_id': laporanId,
      'deskripsi': deskripsi,
      // Nanti kita akan tambahkan data lain yang diupdate
    };

    try {
      final responseData = await _apiService.updateLaporan(laporanData);
      if (responseData['status'] != 'success') {
        throw Exception(responseData['message'] ?? 'Gagal update laporan');
      }
    } catch (e) {
      rethrow;
    }
  }
}

// Provider untuk LaporanRepository
final laporanRepositoryProvider = Provider<LaporanRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return LaporanRepository(apiService);
});
