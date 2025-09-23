import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapor_app/src/core/models/user_model.dart';
import 'package:lapor_app/src/features/auth/application/auth_controller.dart';

class UpdateProfilScreen extends ConsumerStatefulWidget {
  final User user;
  const UpdateProfilScreen({super.key, required this.user});

  @override
  ConsumerState<UpdateProfilScreen> createState() => _UpdateProfilScreenState();
}

class _UpdateProfilScreenState extends ConsumerState<UpdateProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  late final TextEditingController _nomorHpController;
  final ImagePicker _picker = ImagePicker();
  File? _fotoProfilBaru;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user.nama);
    _emailController = TextEditingController(text: widget.user.email);
    _nomorHpController = TextEditingController(text: widget.user.nomorHp);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _nomorHpController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _fotoProfilBaru = File(image.path);
      });
    }
  }

  Future<void> _handleUpdate() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref.read(authControllerProvider.notifier).updateProfil(
            nama: _namaController.text,
            email: _emailController.text,
            nomorHp: _nomorHpController.text,
          );
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui")),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _fotoProfilBaru != null
                        ? FileImage(_fotoProfilBaru!)
                        // : NetworkImage(widget.user.fotoProfilUrl) as ImageProvider, // Gunakan ini nanti
                        : const AssetImage("assets/foto_profil/alya.jpg") as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: "Nama", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Nama tidak boleh kosong" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Email tidak boleh kosong" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomorHpController,
              decoration: const InputDecoration(labelText: "Nomor HP", border: OutlineInputBorder()),
            ),
             const SizedBox(height: 16),
            // Jabatan dibuat tidak bisa diedit
            TextFormField(
                initialValue: widget.user.jabatan,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Jabatan (tidak bisa diubah)",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFF0F0F0),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: authState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton.icon(
                onPressed: _handleUpdate,
                icon: const Icon(Icons.save),
                label: const Text("Simpan Perubahan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
      ),
    );
  }
}