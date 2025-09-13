import 'package:flutter/material.dart';
import 'package:lapor_app/kasek/detail_laporan.dart';

class SemuaLaporanTabKasek extends StatefulWidget {
  const SemuaLaporanTabKasek({super.key});

  @override
  State<SemuaLaporanTabKasek> createState() => _SemuaLaporanTabState();
}

class _SemuaLaporanTabState extends State<SemuaLaporanTabKasek> {
  final List<Map<String, dynamic>> semuaLaporan = [
    {
      'id': '1',
      'user': 'Alya',
      'judul': 'Kerusakan Pintu Ruang Rapat',
      'deskripsi':
          'Pintu ruang rapat lantai 2 tidak bisa ditutup rapat karena engsel longgar. Membahayakan saat ruangan dipakai rapat besar.',
      'foto_before': ['assets/images/maskapai.jpg', 'assets/images/parkir5.jpg'],
      'foto_after': [],
      'status': 'Proses',
      'created_at': '2025-09-01',
      'updated_at': '',
    },
    {
      'id': '2',
      'user': 'Eka',
      'judul': 'Lampu Koridor Mati',
      'deskripsi':
          'Tiga lampu di koridor selatan lantai 1 mati sehingga area menjadi gelap saat malam hari.',
      'foto_before': ['assets/images/maskapai.jpg','assets/images/ruangtunggu2.jpg','assets/images/parkir3.jpg'],
      'foto_after': ['assets/images/penerbangan.jpg','assets/images/maskapai.jpg','assets/images/musholla1.jpg'],
      'status': 'Selesai',
      'created_at': '2025-09-02',
      'updated_at': '2025-09-05',
    },
    {
      'id': '3',
      'user': 'Safitri',
      'judul': 'Kebocoran AC Ruang Server',
      'deskripsi':
          'Terdapat kebocoran air dari AC di ruang server yang menetes ke lantai, berpotensi merusak peralatan elektronik.',
      'foto_before': ['assets/images/penerbangan.jpg','assets/images/maskapai.jpg','assets/images/ruangtunggu2.jpg',],
      'foto_after': [],
      'status': 'Proses',
      'created_at': '2025-09-03',
      'updated_at': '',
    },
  ];

  String query = "";

  @override
  Widget build(BuildContext context) {
    // filter berdasarkan query
    final filtered = semuaLaporan.where((lap) {
      final judul = (lap['judul'] ?? '').toLowerCase();
      return judul.contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Judul + Search
            Row(
              children: [
                const Text(
                  "Semua Laporan",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 200,
                  height: 36,
                  child: TextField(
                    onChanged: (val) {
                      setState(() => query = val);
                    },
                    decoration: InputDecoration(
                      hintText: "Cari...",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      prefixIcon: const Icon(Icons.search, size: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // List laporan
            Expanded(
              child: ListView(
                children: filtered.map((lap) {
                  return _buildListTile(
                    id: lap['id']!,
                    user: lap['user']!,
                    judul: lap['judul']!,
                    deskripsi: lap['deskripsi']!,
                    fotoBefore: List<String>.from(lap['foto_before'] ?? []),
                    fotoAfter: List<String>.from(lap['foto_after'] ?? []),
                    status: lap['status']!,
                    createdAt: lap['created_at']!,
                    updatedAt: lap['updated_at']?.isNotEmpty == true
                        ? lap['updated_at']
                        : null,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String id,
    required String user,
    required String judul,
    required String deskripsi,
    required List<String> fotoBefore,
    required List<String> fotoAfter,
    required String status,
    required String createdAt,
    String? updatedAt,
  }) {
    Color statusColor = status == 'Selesai'
        ? const Color.fromARGB(255, 96, 171, 98)
        : const Color.fromARGB(255, 242, 182, 92);

    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailLaporanPageKasek(
                  id: id,
                  user: user,
                  judul: judul,
                  deskripsi: deskripsi,
                  fotoBefore: fotoBefore,
                  fotoAfter: fotoAfter,
                  status: status,
                  createdAt: createdAt,
                  updatedAt: updatedAt,
                ),
              ),
            );
          },
          title: Text(
            judul,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          subtitle: Text("Tanggal: $createdAt | User: $user"),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
