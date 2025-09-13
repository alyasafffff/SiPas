import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> _pickFotoProfil() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _fotoProfil = File(image.path));
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
              // Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? "Email wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // Nomor HP
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

              // Password
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

              // Jabatan
              TextFormField(
                controller: _jabatanController,
                decoration: const InputDecoration(
                  labelText: "Jabatan",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? "Jabatan wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // Dropdown Role
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

              // Tombol Upload Foto Profil
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

              // Preview Foto Profil
              if (_fotoProfil != null)
                Center(
                  child: CircleAvatar(
                    radius: 90, // ukuran lingkaran
                    backgroundImage: FileImage(_fotoProfil!),
                    backgroundColor:
                        Colors.grey.shade200, // fallback kalau kosong
                  ),
                ),
            ],
          ),
        ),
      ),

      // Tombol Simpan
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_fotoProfil == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Foto Profil wajib diupload")),
                  );
                  return;
                }

                // Simpan user ke backend / database
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User berhasil ditambahkan")),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E2148),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            icon: const Icon(Icons.save),
            label: const Text("Simpan User"),
          ),
        ),
      ),
    );
  }
}
