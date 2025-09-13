import 'package:flutter/material.dart';
import 'package:lapor_app/staff/detail_laporan.dart';
import 'package:lapor_app/staff/tambah_laporan.dart';

class LaporanSayaTab extends StatefulWidget {
  const LaporanSayaTab({super.key});

  @override
  State<LaporanSayaTab> createState() => _LaporanSayaTabState();
}

class _LaporanSayaTabState extends State<LaporanSayaTab> {
  final List<Map<String, dynamic>> laporanSaya = [
    {
      'id': '1',
      'user': 'Alya',
      'judul': 'kabel',
      'deskripsi': 'Kerusakan pada eskalator di gedung keberangkatan lantai 1',
      'foto_before': ['assets/images/maskapai.jpg', 'assets/images/penerbangan.jpg'],
      'foto_after': [], // masih proses jadi kosong
      'status': 'Proses',
      'created_at': '2025-09-01',
      'updated_at': '', // belum ada update
    },
    {
      'id': '2',
      'user': 'Alya',
      'judul': 'eskalator',
      'deskripsi': 'Kerusakan pada eskalator di gedung keberangkatan lantai 1',
      'foto_before': ['assets/images/penerbangan.jpg', 'assets/images/kantin2.jpg'],
      'foto_after': ['assets/images/maskapai.jpg','assets/images/kantin2.jpg','assets/images/parkir5.jpg'],
      'status': 'Selesai',
      'created_at': '2025-09-02',
      'updated_at': '2025-09-05',
    },
    {
      'id': '3',
      'user': 'Alya',
      'judul': 'pintu',
      'deskripsi': 'Kerusakan pada eskalator di gedung keberangkatan lantai 1',
      'foto_before': ['assets/images/maskapai.jpg','assets/images/ruangtunggu2.jpg','assets/images/ruangtunggu2.jpg'],
      'foto_after': [],
      'status': 'Proses',
      'created_at': '2025-09-03',
      'updated_at': '',
    },
  ];

  String query = "";

  @override
  Widget build(BuildContext context) {
    final filtered = laporanSaya.where((lap) {
      final judul = lap['judul']!.toLowerCase();
      return judul.contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Judul + Search
          Row(
            children: [
              const Text(
                "Laporan Saya",
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

          // List laporan hasil filter
          ...filtered.map(
            (lap) => _buildListTile(
              id: lap['id']!,
              user: lap['user']!,
              judul: lap['judul']!,
              deskripsi: lap['deskripsi']!,
              fotoBefore: List<String>.from(lap['foto_before'] ?? []),
              fotoAfter: List<String>.from(lap['foto_after'] ?? []),
              status: lap['status']!,
              createdAt: lap['created_at']!,
              updatedAt: lap['updated_at']!,
            ),
          ),
        ],
      ),

      // Floating button untuk tambah laporan
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 18),
        child: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TambahLaporanPage()),
              );
            },
            backgroundColor: const Color(0xFF0E2148),
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 36),
          ),
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
    required String updatedAt,
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
                builder: (_) => DetailLaporanPage(
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
          subtitle: Text("Tanggal: $createdAt"),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
