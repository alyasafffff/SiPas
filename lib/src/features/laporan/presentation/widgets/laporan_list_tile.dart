import 'package:flutter/material.dart';
import 'package:lapor_app/src/core/models/laporan_model.dart';
import 'package:lapor_app/src/features/laporan/presentation/screens/laporan_detail_screen.dart';

// Nama class diubah menjadi publik (tanpa _)
class LaporanListTile extends StatelessWidget {
  const LaporanListTile({super.key, required this.laporan});

  final Laporan laporan;

  @override
  Widget build(BuildContext context) {
    Color statusColor = laporan.status == 'Selesai'
        ? const Color.fromARGB(255, 96, 171, 98)
        : const Color.fromARGB(255, 242, 182, 92);

    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LaporanDetailScreen(laporan: laporan),
              ),
            );
          },
          title: Text(
            laporan.judul,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text("Dilaporkan oleh: ${laporan.idPelapor}"),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              laporan.status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}