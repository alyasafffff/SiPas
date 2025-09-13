import 'package:flutter/material.dart';
import 'package:lapor_app/PhotoViewPage.dart';
import 'package:lapor_app/kasek/update_laporan.dart';
import 'package:lapor_app/staff/update_laporan.dart';

class DetailLaporanPageKasek extends StatelessWidget {
  final String id;
  final String user;
  final String judul;
  final String deskripsi;
  final List<String> fotoBefore;
  final List<String>? fotoAfter;
  final String status;
  final String createdAt;
  final String? updatedAt;

  const DetailLaporanPageKasek({
    super.key,
    required this.id,
    required this.user,
    required this.judul,
    required this.deskripsi,
    required this.fotoBefore,
    this.fotoAfter,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    const Color appBarColor = Color(0xFF0E2148);
    final Color statusColor = status == 'Selesai'
        ? const Color.fromARGB(255, 96, 171, 98)
        : const Color.fromARGB(255, 242, 182, 92);

    Widget buildPhotoGrid(List<String> images) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: images.map((file) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PhotoViewPage(imagePath: file),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                file,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Detail Laporan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul + status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    judul,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  "Dilaporkan: $createdAt",
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Foto Before
            const Text(
              "Kondisi Sebelum Perbaikan",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            fotoBefore.isNotEmpty
                ? buildPhotoGrid(fotoBefore)
                : const Text("Tidak ada foto"),

            const SizedBox(height: 20),

            // Foto After
            if (fotoAfter != null && fotoAfter!.isNotEmpty) ...[
              const Text(
                "Kondisi Sesudah Perbaikan",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              buildPhotoGrid(fotoAfter!),
              const SizedBox(height: 8),
              if (updatedAt?.isNotEmpty == true)
                Text(
                  "Tanggal Perbaikan: $updatedAt",
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
              const SizedBox(height: 20),
            ],

            // Info Pelapor
            Row(
              children: [
                const Icon(Icons.person, color: Colors.black54, size: 18),
                const SizedBox(width: 6),
                Text(
                  "Pelapor: $user",
                  style: const TextStyle(color: Colors.black87, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.black26),

            // Deskripsi
            const Text(
              "Deskripsi",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              deskripsi,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Tombol Edit
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateLaporanPageKasek(
                        id: id,
                        judul: judul,
                        deskripsi: deskripsi,
                        fotoBefore: fotoBefore, // langsung list
                        fotoAfter: fotoAfter, // langsung list
                        status: status,
                        user: user,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appBarColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
              ),
            ),

            const SizedBox(width: 12),

            // Tombol Hapus
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Tambahkan logic hapus laporan di sini
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Hapus Laporan"),
                      content: const Text(
                        "Apakah Anda yakin ingin menghapus laporan ini?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Batal"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Panggil fungsi hapus di sini
                            Navigator.pop(context); // tutup dialog
                            Navigator.pop(
                              context,
                            ); // kembali ke halaman sebelumnya
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                          ),
                          child: const Text("Hapus"),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.delete),
                label: const Text("Hapus"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
