import 'package:flutter/material.dart';
import 'package:lapor_app/login.dart';
import 'package:lapor_app/staff/detail_laporan.dart';

class DashboardTab extends StatelessWidget {
  DashboardTab({super.key});

  final int laporanProses = 5;
  final int laporanSelesai = 8;

  @override
  Widget build(BuildContext context) {
    // ---------- DATA ----------
    final List<Map<String, dynamic>> laporanTerlama = [
      {
        'id': '1',
        'user': 'Alya',
        'judul': 'kabel',
        'deskripsi':
            'Kerusakan pada eskalator di gedung keberangkatan lantai 1',
        'foto_before': [
          'assets/images/maskapai.jpg',
          'assets/images/musholla1.jpg',
        ],
        'foto_after': [], // masih proses
        'status': 'Proses',
        'created_at': '2025-09-01',
        'updated_at': '',
      },
      {
        'id': '2',
        'user': 'Sari',
        'judul': 'lampu',
        'deskripsi': 'Lampu padam di lorong keberangkatan',
        'foto_before': ['assets/images/maskapai.jpg', 'assets/images/toilet3.jpg'],
        'foto_after': [],
        'status': 'Proses',
        'created_at': '2025-08-02',
        'updated_at': '',
      },
      {
        'id': '5',
        'user': 'Cahaya',
        'judul': 'Pintu rusak',
        'deskripsi': 'Pintu macet di lorong keberangkatan',
        'foto_before': ['assets/images/maskapai.jpg','assets/images/parkir3.jpg','assets/images/ruangtunggu4.jpg'],
        'foto_after': [],
        'status': 'Proses',
        'created_at': '2025-08-02',
        'updated_at': '',
      },
    ];

    final List<Map<String, dynamic>> laporanTerbaru = [
      {
        'id': '3',
        'user': 'Alya',
        'judul': 'AC mati',
        'deskripsi': 'AC tidak berfungsi di ruang tunggu A1',
        'foto_before': ['assets/images/maskapai.jpg','assets/images/parkir3.jpg','assets/images/ruangtunggu4.jpg'],
        'foto_after': [],
        'status': 'Proses',
        'created_at': '2025-09-01',
        'updated_at': '',
      },
      {
        'id': '4',
        'user': 'Rina',
        'judul': 'Toilet bocor',
        'deskripsi': 'Kebocoran pada toilet terminal keberangkatan',
        'foto_before': ['assets/images/maskapai.jpg','assets/images/parkir3.jpg','assets/images/penerbangan.jpg'],
        'foto_after': ['assets/images/maskapai.jpg','assets/images/parkir3.jpg','assets/images/penerbangan.jpg'],
        'status': 'Selesai',
        'created_at': '2025-09-02',
        'updated_at': '2025-09-04',
      },
      {
        'id': '5',
        'user': 'Alya',
        'judul': 'Atap bocor',
        'deskripsi': 'Kebocoran pada atap terminal keberangkatan',
        'foto_before': [
          'assets/images/maskapai.jpg',
          'assets/images/penerbangan.jpg',
        ],
        'foto_after': ['assets/images/penerbangan.jpg','assets/images/parkir3.jpg','assets/images/penerbangan.jpg'],
        'status': 'Selesai',
        'created_at': '2025-09-02',
        'updated_at': '2025-09-07',
      },
    ];

    // --------------------------

    return Container(
      color: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Hallo, Alya!!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildSummaryCard(
                  "Laporan Proses",
                  laporanProses.toString(),
                  Color.fromARGB(255, 242, 182, 92),
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  "Laporan Selesai",
                  laporanSelesai.toString(),
                  Color.fromARGB(255, 96, 171, 98),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Divider(color: Colors.black26, thickness: 1),
            const SizedBox(height: 8),

            const Text(
              "Laporan Butuh Tindakan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: laporanTerlama
                  .map(
                    (lap) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailLaporanPage(
                              id: lap['id'] ?? '',
                              user: lap['user'] ?? '',
                              judul: lap['judul'] ?? '',
                              deskripsi: lap['deskripsi'] ?? '',
                              fotoBefore: List<String>.from(
                                lap['foto_before'] ?? [],
                              ),
                              fotoAfter: List<String>.from(
                                lap['foto_after'] ?? [],
                              ),
                              status: lap['status'] ?? '',
                              createdAt: lap['created_at'] ?? '',
                              updatedAt: lap['updated_at'] ?? '',
                            ),
                          ),
                        );
                      },
                      child: _buildActionCard(
                        lap['judul'] ?? "-",
                        lap['created_at'] ?? "-",
                        lap['user'] ?? "-",
                        Colors.red,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),

            const Divider(color: Colors.black26, thickness: 1),
            const SizedBox(height: 8),

            const Text(
              "Laporan Terbaru",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: laporanTerbaru
                  .map(
                    (lap) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailLaporanPage(
                              id: lap['id'] ?? '',
                              user: lap['user'] ?? '',
                              judul: lap['judul'] ?? '',
                              deskripsi: lap['deskripsi'] ?? '',
                              fotoBefore: List<String>.from(
                                lap['foto_before'] ?? [],
                              ), // FIX
                              fotoAfter: List<String>.from(
                                lap['foto_after'] ?? [],
                              ), // FIX
                              status: lap['status'] ?? '',
                              createdAt: lap['created_at'] ?? '',
                              updatedAt: lap['updated_at'],
                            ),
                          ),
                        );
                      },
                      child: _buildActionCard(
                        lap['judul'] ?? "-",
                        lap['created_at'] ?? "-",
                        lap['user'] ?? "-",
                        Colors.blue,
                        isNew: true,
                        status: lap['status'],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ringkasan
  static Widget _buildSummaryCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // card laporan
  static Widget _buildActionCard(
    String title,
    String tanggal,
    String user,
    Color color, {
    bool isNew = false,
    String? status,
  }) {
    Color statusColor = status == 'Selesai'
        ? const Color.fromARGB(255, 96, 171, 98)
        : const Color.fromARGB(255, 242, 182, 92);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isNew ? Colors.blue[50] : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(isNew ? Icons.fiber_new : Icons.warning, color: color),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          "Tanggal: $tanggal | $user",
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: status != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        dense: true,
      ),
    );
  }
}
