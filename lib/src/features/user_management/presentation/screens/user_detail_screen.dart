import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/core/models/user_model.dart';
import 'package:lapor_app/src/features/user_management/presentation/screens/update_user_screen.dart';

class UserDetailScreen extends ConsumerWidget {
  final User user;
  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color roleColor = user.role.toLowerCase() == 'admin'
        ? Colors.green
        : Colors.orange;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail User"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header: Nama dan Role ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    user.nama,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: roleColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    user.role,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Terdaftar: ${user.tanggalDibuat.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // --- Foto Profil ---
            Center(
              child: CircleAvatar(
                radius: 90,
                backgroundColor: Colors.grey.shade300,
                // backgroundImage: NetworkImage(user.fotoProfilUrl), // Gunakan ini nanti
                backgroundImage: const AssetImage("assets/foto_profil/alya.jpg"), // Placeholder
              ),
            ),
            const SizedBox(height: 20),

            // --- Info Akun ---
            const Text(
              "Info Akun",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildInfoRow("ID User", user.userId),
            _buildInfoRow("Email", user.email),
            _buildInfoRow("Role", user.role),
            _buildInfoRow("Jabatan", user.jabatan),
            _buildInfoRow("Nomor HP", user.nomorHp),
            const SizedBox(height: 20),

            // --- Aktivitas (Placeholder) ---
            const Text(
              "Aktivitas",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: "Laporan Proses",
                    value: "0", // Data ini perlu diambil/dihitung nanti
                    color: Color.fromARGB(255, 242, 182, 92),
                    icon: Icons.pending_actions,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: "Laporan Selesai",
                    value: "0", // Data ini perlu diambil/dihitung nanti
                    color: Color.fromARGB(255, 96, 171, 98),
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
       bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => UpdateUserScreen(user: user),
                  ));
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Tambahkan logika hapus user
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.delete),
                label: const Text("Hapus"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text("$label:", style: const TextStyle(color: Colors.black54)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

// WIDGET KECIL UNTUK STATISTIK
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}