import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/features/auth/application/auth_controller.dart';
import 'package:lapor_app/src/features/auth/presentation/screens/login_screen.dart';
import 'package:lapor_app/src/features/profil/presentation/screens/update_profile_screen.dart';


class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authControllerProvider);

    return Scaffold(
      // AppBar dibuat di halaman navigasi utama, jadi tidak perlu di sini.
      body: userState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (user) {
          if (user == null) {
            // Jika terjadi logout atau state user hilang
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            });
            return const SizedBox.shrink();
          }

          final Color roleColor = user.role.toLowerCase() == 'admin'
              ? Colors.green
              : Colors.orange;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.grey.shade200,
                        // backgroundImage: NetworkImage(user.fotoProfilUrl), // Gunakan ini saat terhubung ke GDrive
                        backgroundImage: const AssetImage("assets/foto_profil/alya.jpg"), // Placeholder
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UpdateProfilScreen(user: user),
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
                Row(
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
                 Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      "Terdaftar: ${user.tanggalDibuat.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("Info Akun", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 8),
                _buildInfoRow("Email", user.email),
                _buildInfoRow("Jabatan", user.jabatan),
                _buildInfoRow("Nomor HP", user.nomorHp),
              ],
            ),
          );
        },
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
            child: Text("$label:", style: const TextStyle(fontSize: 15, color: Colors.black54)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}