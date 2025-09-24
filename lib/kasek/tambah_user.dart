import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapor_app/api_service.dart'; // Hanya butuh import ini untuk API

class TambahUserPage extends StatefulWidget {
  const TambahUserPage({super.key});

  @override
  State<TambahUserPage> createState() => _TambahUserPageState();
}

class _TambahUserPageState extends State<TambahUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();

  String _selectedRole = 'Staff'; // default role
  File? _fotoProfil;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false; // State untuk loading

  Future<void> _pickFotoProfil() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _fotoProfil = File(image.path));
    }
  }

  // Fungsi untuk menangani penyimpanan user
  Future<void> _handleSimpanUser() async {
    if (_formKey.currentState!.validate()) {
      if (_fotoProfil == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto Profil wajib diupload")),
        );
        return;
      }

      setState(() => _isLoading = true);

      // 🔹 Convert File ke Base64
      final bytes = await _fotoProfil!.readAsBytes();
      final fotoBase64 = base64Encode(bytes);
      final ext = _fotoProfil!.path
          .split('.')
          .last; // ambil extension (png/jpg)

      var userData = {
        "user_id": DateTime.now().millisecondsSinceEpoch.toString(),
        "nama": _namaController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "nomor_hp": _hpController.text,
        "jabatan": _jabatanController.text,
        "role": _selectedRole,
        "foto_base64": fotoBase64,
        "foto_ext": ext,
      };

      try {
        final response = await ApiService.post("createUser", userData);

        if (!mounted) return;

        if (response is Map && response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User berhasil ditambahkan"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          final msg = response is Map
              ? (response['message'] ?? "Tidak ada pesan")
              : response.toString();
          throw Exception(msg);
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Terjadi error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tambah User"),
        backgroundColor: const Color(0xFF0E2148),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Semua TextFormField seperti sebelumnya...
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? "Email wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hpController,
                decoration: const InputDecoration(
                  labelText: "Nomor HP",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val!.isEmpty ? "Nomor HP wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val!.isEmpty ? "Password wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _jabatanController,
                decoration: const InputDecoration(
                  labelText: "Jabatan",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? "Jabatan wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: const [
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'Staff', child: Text('Staff')),
                ],
                onChanged: (val) => setState(() => _selectedRole = val!),
                decoration: const InputDecoration(
                  labelText: "Role",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickFotoProfil,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Upload Foto Profil"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: const Color.fromARGB(221, 59, 59, 59),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (_fotoProfil != null)
                Center(
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: FileImage(_fotoProfil!),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _isLoading
                ? null
                : _handleSimpanUser, // Panggil fungsi yang sudah dibuat
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E2148),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            icon: const Icon(Icons.save),
            label: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text("Simpan User"),
          ),
        ),
      ),
    );
  }
}
