import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lapor_app/kasek/detail_laporan.dart';
// import 'package:lapor_app/login.dart'; // kalau tidak dipakai bisa dihapus
import 'package:lapor_app/kasek/semua_laporan.dart'; // pastikan kamu punya halaman ini

class DashboardTabKasek extends StatelessWidget {
  final VoidCallback? onLihatSemua; // callback ke NavigasiKasek

  const DashboardTabKasek({super.key, this.onLihatSemua});

  // contoh ringkasan (dummy)
  final int totalBulanIni = 13;
  final int laporanProses = 5;
  final int laporanSelesai = 8;

  @override
  Widget build(BuildContext context) {
    // ---------- DATA DUMMY ----------
    final List<Map<String, dynamic>> laporanTerlama = [
      {
        'id': '1',
        'user': 'Alya',
        'judul': 'Kabel putus',
        'deskripsi': 'Kerusakan kabel eskalator',
        'foto_before': [
          'assets/images/maskapai.jpg',
          'assets/images/ruangtunggu2.jpg',
        ],
        'foto_after': [],
        'status': 'Proses',
        'created_at': '2025-08-02',
        'updated_at': '',
      },
      {
        'id': '2',
        'user': 'Sari',
        'judul': 'Lampu padam',
        'deskripsi': 'Lampu lorong keberangkatan mati',
        'foto_before': ['assets/images/maskapai.jpg'],
        'foto_after': [],
        'status': 'Proses',
        'created_at': '2025-08-03',
        'updated_at': '',
      },
      {
        'id': '3',
        'user': 'Sari',
        'judul': 'Lantai retak',
        'deskripsi': 'Lantai retak di lorong keberangkatan ',
        'foto_before': ['assets/images/maskapai.jpg'],
        'foto_after': [],
        'status': 'Proses',
        'created_at': '2025-08-03',
        'updated_at': '',
      },
    ];

    final List<Map<String, dynamic>> laporanTerbaru = [
      {
        'id': '4',
        'user': 'Alya',
        'judul': 'AC mati',
        'deskripsi': 'AC ruang tunggu A1 tidak berfungsi',
        'foto_before': [
          'assets/images/maskapai.jpg',
          'assets/images/parkir3.jpg',
        ],
        'foto_after': [],
        'status': 'Proses',
        'created_at': '2025-09-07',
        'updated_at': '',
      },
      {
        'id': '5',
        'user': 'Rina',
        'judul': 'Toilet bocor',
        'deskripsi': 'Kebocoran pada toilet terminal keberangkatan',
        'foto_before': ['assets/images/maskapai.jpg'],
        'foto_after': [
          'assets/images/maskapai.jpg',
          'assets/images/kantin2.jpg',
        ],
        'status': 'Selesai',
        'created_at': '2025-09-08',
        'updated_at': '2025-09-08',
      },
      {
        'id': '6',
        'user': 'Eka',
        'judul': 'Pintu macet',
        'deskripsi': 'Pintu macet pada toilet terminal keberangkatan',
        'foto_before': ['assets/images/maskapai.jpg'],
        'foto_after': [
          'assets/images/maskapai.jpg',
          'assets/images/kantin2.jpg',
        ],
        'status': 'Selesai',
        'created_at': '2025-09-08',
        'updated_at': '2025-09-08',
      },
    ];

    // data statistik bulanan (dummy)
    final List<Map<String, dynamic>> laporanBulanan = [
      {'bulan': 1, 'jumlah': 4},
      {'bulan': 2, 'jumlah': 6},
      {'bulan': 3, 'jumlah': 3},
      {'bulan': 4, 'jumlah': 7},
      {'bulan': 5, 'jumlah': 5},
      {'bulan': 6, 'jumlah': 9},
      {'bulan': 7, 'jumlah': 4},
      {'bulan': 8, 'jumlah': 10},
      {'bulan': 9, 'jumlah': 8},
      {'bulan': 10, 'jumlah': 12},
      {'bulan': 11, 'jumlah': 7},
      {'bulan': 12, 'jumlah': 6},
    ];

    DateTime now = DateTime.now();

    // ambil 6 bulan terakhir
    List<Map<String, dynamic>> laporan6Bulan = List.generate(6, (i) {
      DateTime bulan = DateTime(now.year, now.month - 5 + i);
      int bulanIndex = bulan.month;

      // cari jumlah laporan dari data
      final data = laporanBulanan.firstWhere(
        (row) => row['bulan'] == bulanIndex,
        orElse: () => {'bulan': bulanIndex, 'jumlah': 0},
      );

      return {
        'label': [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'Mei',
          'Jun',
          'Jul',
          'Agu',
          'Sep',
          'Okt',
          'Nov',
          'Des',
        ][bulanIndex - 1],
        'jumlah': data['jumlah'],
      };
    });

    // labels untuk X axis
    final List<String> bulan6Terakhir = laporan6Bulan
        .map((row) => row['label'] as String)
        .toList();

    // spots untuk grafik
    final List<FlSpot> spots6Bulan = laporan6Bulan.asMap().entries.map((entry) {
      int idx = entry.key; // 0-5
      var row = entry.value;
      return FlSpot(
        (idx + 1).toDouble(), // X axis 1–6
        (row['jumlah'] as int).toDouble(), // Y axis jumlah laporan
      );
    }).toList();

    // -------------------------------
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Statistik Bulanan ----------
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SemuaLaporanTabKasek(),
                  ), // ganti halaman ini sesuai projekmu
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- Statistik Bulanan ----------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Statistik Laporan 6 Bulan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton.icon(
                        onPressed:
                            onLihatSemua, // panggil callback dari NavigasiKasek
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.blue,
                        ),
                        label: const Text(
                          "Lihat Semua",
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                reservedSize: 32,
                                getTitlesWidget: (value, meta) {
                                  if (value >= 1 && value <= 6) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 8, // kasih jarak biar gak nempel
                                      child: Text(
                                        bulan6Terakhir[value.toInt() - 1],
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),

                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: const Border(
                              left: BorderSide(color: Colors.black26, width: 1),
                              bottom: BorderSide(
                                color: Colors.black26,
                                width: 1,
                              ),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              color: const Color(0xFF0E2148),
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(show: false),
                              spots:
                                  spots6Bulan, // sekarang fix hanya 6 bulan terakhir
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black26, thickness: 1),
            const SizedBox(height: 8),

            // ---------- Laporan Terlama ----------
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
                            builder: (_) => DetailLaporanPageKasek(
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
                              updatedAt: lap['updated_at'],
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

            // ---------- Laporan Terbaru ----------
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
                            builder: (_) => DetailLaporanPageKasek(
                              id: lap['id'],
                              user: lap['user'],
                              judul: lap['judul'],
                              deskripsi: lap['deskripsi'],
                              fotoBefore: List<String>.from(
                                lap['foto_before'] ?? [],
                              ),
                              fotoAfter: List<String>.from(
                                lap['foto_after'] ?? [],
                              ),
                              status: lap['status'],
                              createdAt: lap['created_at'],
                              updatedAt: lap['updated_at'] ?? '',
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

  // ---------- CARD RINGKASAN ----------
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

  // ---------- CARD LAPORAN ----------
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
