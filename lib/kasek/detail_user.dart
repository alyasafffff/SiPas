import 'package:flutter/material.dart';
import 'package:lapor_app/PhotoViewPage.dart';
import 'package:lapor_app/api_service.dart';
import 'package:lapor_app/kasek/update_user.dart';

class DetailUserPage extends StatelessWidget {
  final String id;
  final String nama;
  final String email;
  final String role;
  final String createdAt;
  final String? nomorHp;
  final String? jabatan;
  final int? laporanProses;
  final int? laporanSelesai;
  final String? fotoProfil; // <--- tambahkan fotoProfil

  const DetailUserPage({
    super.key,
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    required this.createdAt,
    this.nomorHp,
    this.jabatan,
    this.laporanProses,
    this.laporanSelesai,
    this.fotoProfil,
  });

  @override
  Widget build(BuildContext context) {
    const Color appBarColor = Color(0xFF0E2148);
    final Color roleColor = role.toLowerCase() == 'admin'
        ? Colors.green
        : Colors.orange;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Detail User",
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
            // FOTO PROFIL

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
            Center(
              child: GestureDetector(
                onTap: () {
                  if (fotoProfil != null && fotoProfil!.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PhotoViewPage(imagePath: fotoProfil!),
                      ),
                    );
                  }
                },
                child: CircleAvatar(
                  radius: 90,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage:
                      (fotoProfil != null && fotoProfil!.isNotEmpty)
                      ? (fotoProfil!.startsWith('http')
                            ? NetworkImage(fotoProfil!)
                            : AssetImage(fotoProfil!) as ImageProvider)
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ================= Info Akun =================
            const Text(
              "Info Akun",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildInfoRow("ID User", id),
            _buildInfoRow("Email", email),
            _buildInfoRow("Role", role),
            _buildInfoRow("Jabatan", jabatan ?? "-"),

            _buildInfoRow("Nomor HP", nomorHp ?? "-"),
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
                    value: "${laporanProses ?? 0}",
                    color: const Color.fromARGB(255, 242, 182, 92), // oranye
                    icon: Icons.pending_actions,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: "Laporan Selesai",
                    value: "${laporanSelesai ?? 0}",
                    color: const Color.fromARGB(255, 96, 171, 98), // hijau
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // Bottom Bar Edit + Hapus
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigasi ke halaman UpdateUserPage sambil membawa data user
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateUserPage(
                        id: id,
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
            Expanded(
              child: StatefulBuilder(
                builder: (context, setState) {
                  bool isLoading = false;

                  return ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Konfirmasi Hapus"),
                                content: Text(
                                  "Apakah Anda yakin ingin menghapus user $nama?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text(
                                      "Hapus",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm != true) return;

                            setState(() => isLoading = true);

                            try {
                              final response = await ApiService.post(
                                "deleteUser",
                                {"id": id},
                              );

                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("User berhasil dihapus"),
                                  ),
                                );
                                Navigator.pop(
                                  context,
                                ); // Kembali ke halaman sebelumnya
                              } else {
                                throw Exception(
                                  response['message'] ?? "Gagal hapus user",
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error: ${e.toString()}"),
                                ),
                              );
                            } finally {
                              if (context.mounted)
                                setState(() => isLoading = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.delete),
                    label: Text(isLoading ? "Menghapus..." : "Hapus"),
                  );
                },
              ),
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
                style: TextStyle(
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
