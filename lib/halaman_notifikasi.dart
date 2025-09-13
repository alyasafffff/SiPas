import 'package:flutter/material.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  // List notifikasi sementara dengan data dummy
  List<String> _notifikasi = [
    "Laporan 'Lampu padam' berhasil dibuat",
    "Laporan 'Kabel putus' berhasil dibuat",
    "Laporan 'AC mati' berhasil dibuat",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E2148),
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Warna ikon back
        ),
      ),
      body: _notifikasi.isEmpty
          ? const Center(
              child: Text(
                "Belum ada notifikasi",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _notifikasi.length,
              itemBuilder: (context, index) {
                final notif = _notifikasi[index];
                return Card(
                  elevation: 0.1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.notifications, color: Colors.blue),
                    ),
                    title: Text(
                      notif,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: const Text(
                      "Baru saja",
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                );
              },
            ),
    );
  }

  // Fungsi untuk menambahkan notifikasi baru
  void tambahNotifikasi(String pesan) {
    setState(() {
      _notifikasi.insert(0, pesan); // ditambahkan di atas
    });
  }
}
