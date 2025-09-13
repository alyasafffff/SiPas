import 'package:flutter/material.dart';
import 'package:lapor_app/kasek/detail_user.dart';
import 'package:lapor_app/kasek/tambah_user.dart';

class ManajemenUserPage extends StatefulWidget {
  const ManajemenUserPage({super.key});

  @override
  State<ManajemenUserPage> createState() => _ManajemenUserPageState();
}

class _ManajemenUserPageState extends State<ManajemenUserPage> {
  final List<Map<String, String>> semuaUser = [
    {
      'id': '1',
      'nama': 'Alya Eka',
      'email': 'alya@example.com',
      'role': 'Admin',
      'created_at': '2025-08-01',
      'nomor_hp': '081234567890',
      'jabatan': 'kepala seksi',
      'foto_profil': 'assets/foto_profil/alya.jpg',
    },
    {
      'id': '2',
      'nama': 'Eka Safitri',
      'email': 'eka@example.com',
      'role': 'Staff',
      'created_at': '2025-08-03',
      'nomor_hp': '081222334455',
      'jabatan': 'Staff TU',
      'foto_profil': 'assets/foto_profil/alya.jpg',
    },
    {
      'id': '3',
      'nama': 'Safitri',
      'email': 'safitri@example.com',
      'role': 'Staff',
      'created_at': '2025-08-05',
      'nomor_hp': '081998877665',
      'jabatan': 'Staff Teknik',
      'foto_profil': 'assets/foto_profil/alya.jpg',
    },
  ];

  String query = "";

  @override
  Widget build(BuildContext context) {
    final filtered = semuaUser.where((user) {
      final nama = user['nama']!.toLowerCase();
      return nama.contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header + search
            Row(
              children: [
                const Text(
                  "User",
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
                    onChanged: (val) => setState(() => query = val),
                    decoration: InputDecoration(
                      hintText: "Cari user...",
                      prefixIcon: const Icon(Icons.search, size: 18),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
            Expanded(
              child: ListView(
                children: filtered.map((u) => _buildUserTile(u)).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
          bottom: 12,
          right: 18,
        ), // jarak dari bawah & kanan
        child: SizedBox(
          width: 60, // lebar tombol
          height: 60, // tinggi tombol → bikin bulat sempurna
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TambahUserPage()),
              );
            },
            backgroundColor: const Color(0xFF0E2148), // warna tombol
            foregroundColor: Colors.white, // warna icon
            shape: const CircleBorder(), // pastikan bulat
            child: const Icon(Icons.add, size: 36), // icon lebih besar
          ),
        ),
      ),
    );
  }

  Widget _buildUserTile(Map<String, String> user) {
    Color roleColor = user['role']!.toLowerCase() == 'admin'
        ? Colors.green
        : Colors.orange;

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: user['foto_profil']!.startsWith('http')
                ? NetworkImage(user['foto_profil']!) as ImageProvider
                : AssetImage(user['foto_profil']!),
          ),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailUserPage(
                  id: user['id']!,
                  nama: user['nama']!,
                  email: user['email']!,
                  role: user['role']!,
                  createdAt: user['created_at']!,
                  nomorHp: user['nomor_hp']!,
                  jabatan: user['jabatan']!,
                  fotoProfil: user['foto_profil']!,
                ),
              ),
            );
          },
          title: Text(
            user['nama']!,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            "Email: ${user['email']}\nTerdaftar: ${user['created_at']}",
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: roleColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              user['role']!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
