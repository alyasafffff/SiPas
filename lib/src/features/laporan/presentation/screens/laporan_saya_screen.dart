import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/features/laporan/application/laporan_controller.dart';
import 'package:lapor_app/src/features/laporan/presentation/widgets/laporan_list_tile.dart';

class LaporanSayaScreen extends ConsumerWidget {
  const LaporanSayaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Gunakan provider yang sudah difilter
    final laporanSayaList = ref.watch(laporanSayaProvider);
    // Kita juga pantau state asli untuk menampilkan loading/error
    final laporanAsyncState = ref.watch(laporanControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Saya"),
      ),
      body: laporanAsyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (_) { // Abaikan data dari sini, kita pakai yang sudah difilter
          if (laporanSayaList.isEmpty) {
            return const Center(child: Text("Anda belum membuat laporan."));
          }
          return ListView.builder(
            itemCount: laporanSayaList.length,
            itemBuilder: (context, index) {
              final laporan = laporanSayaList[index];
              // Kita bisa pakai ulang widget _LaporanListTile
              return LaporanListTile(laporan: laporan);
            },
          );
        },
      ),
    );
  }
}