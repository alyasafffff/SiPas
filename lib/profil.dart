import 'package:flutter/material.dart';
import 'package:lapor_app/PhotoViewPage.dart';
import 'package:lapor_app/login.dart';
import 'package:lapor_app/update_profil.dart';
import 'package:photo_view/photo_view.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk profil
    final String nama = "Alya Eka";
    final String email = "alya@example.com";
    final String role = "Admin";
    final String createdAt = "2025-08-01";
    final String jabatan = "Kepala Seksi";
    final String nomorHp = "081234567890";
    final String fotoProfil = "assets/foto_profil/alya.jpg";
    final int laporanProses = 5;
    final int laporanSelesai = 8;

    final Color roleColor = role.toLowerCase() == 'admin'
        ? Colors.green
        : Colors.orange;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Profil",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Row(
                children: const [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 4),
                  Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Profil + tombol edit
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (fotoProfil != null && fotoProfil!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PhotoViewPage(imagePath: fotoProfil!),
                          ),
                        );
                      }
                    },
                    child: CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          (fotoProfil != null && fotoProfil!.isNotEmpty)
                          ? (fotoProfil!.startsWith('http')
                                ? NetworkImage(fotoProfil!)
                                : AssetImage(fotoProfil!) as ImageProvider)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UpdateProfilPage(
                              nama: nama,
                              email: email,
                              role: role,
                              jabatan: jabatan,
                              nomorHp: nomorHp,
                              fotoProfil: fotoProfil,
                            ),
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 23,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.edit, size: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Nama + Role
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    nama,
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
                    color: roleColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    role,
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
                  "Terdaftar: $createdAt",
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ================= Info Akun =================
            const Text(
              "Info Akun",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildInfoRow("Email", email),
            _buildInfoRow("Role", role),
            _buildInfoRow("Jabatan", jabatan),
            _buildInfoRow("Nomor HP", nomorHp),
            const SizedBox(height: 20),

            // ================= Aktivitas =================
            const Text(
              "Aktivitas",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: "Laporan Proses",
                    value: "$laporanProses",
                    color: const Color.fromARGB(255, 242, 182, 92),
                    icon: Icons.pending_actions,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: "Laporan Selesai",
                    value: "$laporanSelesai",
                    color: const Color.fromARGB(255, 96, 171, 98),
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
