import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/core/models/user_model.dart';
import 'package:lapor_app/src/features/user_management/application/user_controller.dart';

class UpdateUserScreen extends ConsumerStatefulWidget {
  final User user;
  const UpdateUserScreen({super.key, required this.user});

  @override
  ConsumerState<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends ConsumerState<UpdateUserScreen> {
  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  late final TextEditingController _nomorHpController;
  late final TextEditingController _jabatanController;
  late String _selectedRole;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user.nama);
    _emailController = TextEditingController(text: widget.user.email);
    _nomorHpController = TextEditingController(text: widget.user.nomorHp);
    _jabatanController = TextEditingController(text: widget.user.jabatan);
    _selectedRole = widget.user.role;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _nomorHpController.dispose();
    _jabatanController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateUser() async {
    final userData = {
      'user_id': widget.user.userId,
      'nama': _namaController.text,
      'email': _emailController.text,
      'nomor_hp': _nomorHpController.text,
      'jabatan': _jabatanController.text,
      'role': _selectedRole,
    };

    final success = await ref.read(userControllerProvider.notifier).updateUser(userData);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data user berhasil diperbarui")),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Update User")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Di sini bisa ditambahkan preview foto user
          const SizedBox(height: 16),
          TextFormField(controller: _namaController, decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextFormField(controller: _nomorHpController, decoration: const InputDecoration(labelText: "Nomor HP", border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextFormField(controller: _jabatanController, decoration: const InputDecoration(labelText: "Jabatan", border: OutlineInputBorder())),
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
          // Bisa ditambahkan field untuk ganti password jika perlu
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton.icon(
              onPressed: _handleUpdateUser,
              icon: const Icon(Icons.save),
              label: const Text("Simpan Perubahan"),
            ),
      ),
    );
  }
}