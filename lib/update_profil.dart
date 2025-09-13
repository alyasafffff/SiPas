import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfilPage extends StatefulWidget {
  final String nama;
  final String email;
  final String role;
  final String jabatan;
  final String nomorHp;
  final String fotoProfil;

  const UpdateProfilPage({
    super.key,
    required this.nama,
    required this.email,
    required this.role,
    required this.jabatan,
    required this.nomorHp,
    required this.fotoProfil,
  });

  @override
  State<UpdateProfilPage> createState() => _UpdateProfilPageState();
}

class _UpdateProfilPageState extends State<UpdateProfilPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _jabatanController;
  late TextEditingController _nomorHpController;

  File? _fotoProfil;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.nama);
    _emailController = TextEditingController(text: widget.email);
    _jabatanController = TextEditingController(text: widget.jabatan);
    _nomorHpController = TextEditingController(text: widget.nomorHp);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _fotoProfil = File(image.path);
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: kirim data ke backend API update profil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: const Color(0xFF0E2148),
        foregroundColor: Colors.white, // <-- ini akan membuat teks title putih
        iconTheme: const IconThemeData(color: Colors.white), // ikon back putih
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Foto Profil
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _fotoProfil != null
                          ? FileImage(_fotoProfil!)
                          : AssetImage(widget.fotoProfil) as ImageProvider,
                      child: (_fotoProfil == null && widget.fotoProfil.isEmpty)
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white70,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Email tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),

              // Nomor HP
              TextFormField(
                controller: _nomorHpController,
                decoration: const InputDecoration(
                  labelText: "Nomor HP",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Jabatan (tidak bisa diedit)
              TextFormField(
                controller: _jabatanController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Jabatan",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),
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
            onPressed: _saveProfile,
            icon: const Icon(Icons.save),
            label: const Text("Simpan Perubahan"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E2148),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
