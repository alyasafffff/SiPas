import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/core/models/laporan_model.dart';
import 'package:lapor_app/src/features/auth/application/auth_controller.dart';
import 'package:lapor_app/src/features/laporan/presentation/screens/update_laporan_screen.dart';

class LaporanDetailScreen extends ConsumerWidget {
  final Laporan laporan;
  const LaporanDetailScreen({super.key, required this.laporan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- INI BAGIAN PERBAIKANNYA ---
    // Ambil data user yang sedang login dari provider
    final currentUserState = ref.watch(authControllerProvider);
    final currentUser = currentUserState.value;
    // -----------------------------

    final Color statusColor = laporan.status == 'Selesai'
        ? const Color.fromARGB(255, 96, 171, 98)
        : const Color.fromARGB(255, 242, 182, 92);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Laporan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    laporan.judul,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    laporan.status,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.calendar_today,
              text: "Dilaporkan: ${laporan.tanggalDibuat.toLocal().toString().split(' ')[0]}",
            ),
            const SizedBox(height: 4),
            _buildInfoRow(
              icon: Icons.person,
              text: "Pelapor: ${laporan.idPelapor}",
            ),
            const SizedBox(height: 20),
            const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 8),
            Text(laporan.deskripsi, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 20),
            const Text("Foto Sebelum Perbaikan", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 8),
            _buildPhotoGrid(laporan.linkFotoBefore),
            const SizedBox(height: 20),
            if (laporan.linkFotoAfter != null && laporan.linkFotoAfter!.isNotEmpty) ...[
              const Text("Foto Sesudah Perbaikan", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              _buildPhotoGrid(laporan.linkFotoAfter!),
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.calendar_today,
                text: "Selesai: ${laporan.tanggalSelesai?.toLocal().toString().split(' ')[0] ?? '-'}",
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: (currentUser?.userId == laporan.idPelapor && laporan.status != 'Selesai')
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => UpdateLaporanScreen(laporan: laporan),
                  ));
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Laporan"),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.black54, fontSize: 14)),
      ],
    );
  }

  Widget _buildPhotoGrid(String photoLinks) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text("Preview Foto Belum Tersedia"),
      ),
      height: 120,
    );
  }
}