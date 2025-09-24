// --- IMPORT TAMBAHAN ---
// Pastikan 3 baris import ini ada di bagian atas file Anda.
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
// -----------------------

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapor_app/src/features/user_management/application/user_controller.dart';

class TambahUserScreen extends ConsumerStatefulWidget {
  const TambahUserScreen({super.key});

  @override
  ConsumerState<TambahUserScreen> createState() => _TambahUserScreenState();
}

class _TambahUserScreenState extends ConsumerState<TambahUserScreen> {
  // Semua variabel Anda tetap di sini
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _hpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _jabatanController = TextEditingController();
  String _selectedRole = 'Staff';
  File? _fotoProfil;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    _passwordController.dispose();
    _jabatanController.dispose();
    super.dispose();
  }
  
  // --- FUNGSI BARU ---
  // Tambahkan fungsi untuk memilih gambar
  Future<void> _pickFotoProfil() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _fotoProfil = File(image.path));
    }
  }

  // Fungsi kompresi yang Anda bingung letakkan di sini
  Future<File?> _compressFile(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(dir.absolute.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 60, // Kualitas gambar (0-100)
    );

    if (result != null) {
      return File(result.path);
    }
    return null;
  }

  // Ganti fungsi _handleSimpanUser Anda yang lama dengan yang ini
  Future<void> _handleSimpanUser() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_fotoProfil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto Profil wajib diupload")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Blok kompresi gambar
    File? compressedFoto = await _compressFile(_fotoProfil!);
    if (compressedFoto == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengompres gambar.")),
        );
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      final userData = {
        "nama": _namaController.text,
        "email": _emailController.text,
        "nomor_hp": _hpController.text,
        "password": _passwordController.text,
        "jabatan": _jabatanController.text,
        "role": _selectedRole,
      };

      // Gunakan file yang sudah dikompresi
      await ref
          .read(userControllerProvider.notifier)
          .addUser(userData: userData, fotoProfil: compressedFoto);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User berhasil ditambahkan"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Menampilkan pesan error yang lebih jelas
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menyimpan: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bagian build() Anda sudah benar, tidak perlu diubah.
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah User")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Email wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hpController,
              decoration: const InputDecoration(labelText: "Nomor HP", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Password wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _jabatanController,
              decoration: const InputDecoration(labelText: "Jabatan", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Jabatan wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: const [
                DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                DropdownMenuItem(value: 'Staff', child: Text('Staff')),
              ],
              onChanged: (val) => setState(() => _selectedRole = val!),
              decoration: const InputDecoration(labelText: "Role", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickFotoProfil, // Pastikan tombol ini memanggil _pickFotoProfil
              icon: const Icon(Icons.camera_alt),
              label: const Text("Upload Foto Profil"),
            ),
            const SizedBox(height: 16),
            if (_fotoProfil != null)
              Center(
                child: CircleAvatar(
                  radius: 90,
                  backgroundImage: FileImage(_fotoProfil!),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: _isLoading ? null : _handleSimpanUser,
          icon: _isLoading
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : const Icon(Icons.save),
          label: Text(_isLoading ? "Menyimpan..." : "Simpan User"),
        ),
      ),
    );
  }
}