import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/features/laporan/application/laporan_controller.dart';
import 'package:lapor_app/src/features/laporan/presentation/widgets/laporan_list_tile.dart';

// 1. Gunakan ConsumerWidget untuk bisa mengakses 'ref'
class SemuaLaporanScreen extends ConsumerWidget {
  const SemuaLaporanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. Pantau state dari laporanControllerProvider
    final laporanState = ref.watch(laporanControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua Laporan"),
      ),
      body:
      // 3. Gunakan .when() untuk menangani semua kemungkinan state
      laporanState.when(
        // Tampilan saat data sedang dimuat
        loading: () => const Center(child: CircularProgressIndicator()),

        // Tampilan saat terjadi error
        error: (error, stackTrace) => Center(child: Text('Error: $error')),

        // Tampilan saat data berhasil dimuat
        data: (laporanList) {
          // Jika tidak ada laporan
          if (laporanList.isEmpty) {
            return const Center(child: Text("Belum ada laporan."));
          }

          // Jika ada laporan, tampilkan dalam bentuk list
          return ListView.builder(
            itemCount: laporanList.length,
            itemBuilder: (context, index) {
              final laporan = laporanList[index];
              return LaporanListTile(laporan: laporan);
            },
          );
        },
      ),
    );
  }
}