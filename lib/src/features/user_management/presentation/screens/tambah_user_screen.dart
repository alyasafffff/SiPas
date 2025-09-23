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
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _hpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _jabatanController = TextEditingController();
  String _selectedRole = 'Staff';
  File? _fotoProfil;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    _passwordController.dispose();
    _jabatanController.dispose();
    super.dispose();
  }

  Future<void> _pickFotoProfil() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _fotoProfil = File(image.path));
    }
  }

  Future<void> _handleSimpanUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_fotoProfil == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto Profil wajib diupload")),
        );
        return;
      }

      final success = await ref.read(userControllerProvider.notifier).addUser(
            nama: _namaController.text,
            email: _emailController.text,
            nomorHp: _hpController.text,
            password: _passwordController.text,
            jabatan: _jabatanController.text,
            role: _selectedRole,
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User berhasil ditambahkan")),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah User")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(controller: _namaController, decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null),
            const SizedBox(height: 16),
            TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? "Email wajib diisi" : null),
            const SizedBox(height: 16),
            TextFormField(controller: _hpController, decoration: const InputDecoration(labelText: "Nomor HP", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? "Password wajib diisi" : null),
            const SizedBox(height: 16),
            TextFormField(controller: _jabatanController, decoration: const InputDecoration(labelText: "Jabatan", border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? "Jabatan wajib diisi" : null),
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
            ElevatedButton.icon(onPressed: _pickFotoProfil, icon: const Icon(Icons.camera_alt), label: const Text("Upload Foto Profil")),
            const SizedBox(height: 8),
            if (_fotoProfil != null)
              Center(child: CircleAvatar(radius: 90, backgroundImage: FileImage(_fotoProfil!))),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton.icon(
              onPressed: _handleSimpanUser,
              icon: const Icon(Icons.save),
              label: const Text("Simpan User"),
            ),
      ),
    );
  }
}