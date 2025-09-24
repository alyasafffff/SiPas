import 'package:flutter/material.dart';
import 'package:lapor_app/api_service.dart'; // Import ApiService
import 'package:lapor_app/kasek/detail_user.dart';
import 'package:lapor_app/kasek/tambah_user.dart';

class ManajemenUserPage extends StatefulWidget {
  const ManajemenUserPage({super.key});

  @override
  State<ManajemenUserPage> createState() => _ManajemenUserPageState();
}

class _ManajemenUserPageState extends State<ManajemenUserPage> {
  // Ganti data dummy menjadi list kosong yang akan diisi dari API
  List<Map<String, dynamic>> _semuaUser = [];
  String _query = "";
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Panggil fungsi untuk mengambil data saat halaman pertama kali dibuka
  }

  // Fungsi untuk mengambil data user dari API
  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await ApiService.get("getUsers");
      if (response['status'] == 'success') {
        // Pastikan data yang diterima adalah List<dynamic>
        final List<dynamic> data = response['data'];
        setState(() {
          // Konversi setiap item di list menjadi Map<String, dynamic>
          _semuaUser = data.map((item) => Map<String, dynamic>.from(item)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final filtered = _semuaUser.where((user) {
      final nama = user['nama']?.toString().toLowerCase() ?? '';
      return nama.contains(_query.toLowerCase());
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
                    onChanged: (val) => setState(() => _query = val),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Text(
                            "Error: $_errorMessage",
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchUsers,
                          child: ListView(
                            children: filtered.map((u) => _buildUserTile(u)).toList(),
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
          bottom: 12,
          right: 18,
        ),
        child: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            onPressed: () async {
              // Navigasi ke halaman tambah user dan tunggu hasilnya
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TambahUserPage()),
              );
              // Setelah kembali, panggil ulang _fetchUsers untuk refresh data
              if (mounted) {
                 _fetchUsers();
              }
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

  Widget _buildUserTile(Map<String, dynamic> user) {
    Color roleColor = (user['role']?.toString().toLowerCase() ?? '') == 'admin'
        ? Colors.green
        : Colors.orange;

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(user['link_foto_profil'] ?? 'https://via.placeholder.com/150'),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailUserPage(
                  id: user['user_id'].toString(),
                  nama: user['nama'] ?? '-',
                  email: user['email'] ?? '-',
                  role: user['role'] ?? '-',
                  createdAt: user['tanggal_dibuat']?.toString() ?? '-',
                  nomorHp: user['nomor_hp'] ?? '-',
                  jabatan: user['jabatan'] ?? '-',
                  fotoProfil: user['link_foto_profil'],
                ),
              ),
            );
          },
          title: Text(
            user['nama'] ?? "Nama Tidak Tersedia",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            "Email: ${user['email']}\nTerdaftar: ${user['tanggal_dibuat']}",
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: roleColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              user['role'] ?? "Role",
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