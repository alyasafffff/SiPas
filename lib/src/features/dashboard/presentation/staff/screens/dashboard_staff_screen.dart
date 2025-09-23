import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardStaffScreen extends ConsumerWidget {
  const DashboardStaffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Data ini nanti akan kita ambil dari provider
    const String namaUser = "Alya";
    const int laporanProses = 5;
    const int laporanSelesai = 8;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hallo, $namaUser!!",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildSummaryCard(
                  "Laporan Proses",
                  laporanProses.toString(),
                  const Color.fromARGB(255, 242, 182, 92),
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  "Laporan Selesai",
                  laporanSelesai.toString(),
                  const Color.fromARGB(255, 96, 171, 98),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            // Di sini nanti kita akan menampilkan daftar laporan terbaru/butuh tindakan
            const Text(
              "Laporan Terbaru",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // ListView untuk laporan terbaru bisa ditambahkan di sini
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 8),
            Text(count, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}