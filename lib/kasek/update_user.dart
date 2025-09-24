import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:lapor_app/api_service.dart';

class UpdateUserPage extends StatefulWidget {
  final String id;
  final String nama;
  final String email;
  final String role;
  final String? jabatan;
  final String? nomorHp;
  final String? fotoProfil;

  const UpdateUserPage({
    super.key,
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    this.jabatan,
    this.nomorHp,
    this.fotoProfil,
  });

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _jabatanController;
  late TextEditingController _nomorHpController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController =
      TextEditingController();

  File? _fotoProfil;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.nama);
    _emailController = TextEditingController(text: widget.email);
    _jabatanController = TextEditingController(text: widget.jabatan ?? '');
    _nomorHpController = TextEditingController(text: widget.nomorHp ?? '');
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _fotoProfil = File(image.path);
      });
    }
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text.isNotEmpty &&
          _passwordController.text != _konfirmasiPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password dan konfirmasi tidak sama")),
        );
        return;
      }

      try {
        setState(() => _isLoading = true);
        String? fotoBase64;
        String? ext;

        if (_fotoProfil != null) {
          final bytes = await _fotoProfil!.readAsBytes();
          fotoBase64 = base64Encode(bytes);
          ext = _fotoProfil!.path.split('.').last;
        }

        var userData = {
          "id": widget.id, // penting untuk identifikasi user
          "nama": _namaController.text,
          "email": _emailController.text,
          "jabatan": _jabatanController.text,
          "nomor_hp": _nomorHpController.text,
          "role": widget.role,
          "password": _passwordController.text.isNotEmpty
              ? _passwordController.text
              : null, // kalau kosong jangan update password
          "foto_base64": fotoBase64,
          "foto_ext": ext,
        };

        final response = await ApiService.post("updateUser", userData);

        if (!mounted) return;

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User berhasil diupdate")),
          );
          Navigator.pop(context);
        } else {
          throw Exception(response['message'] ?? "Update gagal");
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      } finally {
        if (mounted) {
          setState(() => _isLoading = false); // 🔹 Matikan loading
        }
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Edit User"),
            backgroundColor: const Color(0xFF0E2148),
            foregroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // FOTO PROFIL
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _fotoProfil != null
                              ? FileImage(_fotoProfil!) as ImageProvider
                              : (widget.fotoProfil != null &&
                                        widget.fotoProfil!.isNotEmpty
                                    ? NetworkImage(widget.fotoProfil!)
                                    : null),
                          child:
                              (_fotoProfil == null &&
                                  (widget.fotoProfil == null ||
                                      widget.fotoProfil!.isEmpty))
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

                  // NAMA
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

                  // EMAIL
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

                  // JABATAN
                  TextFormField(
                    controller: _jabatanController,
                    decoration: const InputDecoration(
                      labelText: "Jabatan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // NOMOR HP
                  TextFormField(
                    controller: _nomorHpController,
                    decoration: const InputDecoration(
                      labelText: "Nomor HP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // PASSWORD
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password Baru (opsional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // KONFIRMASI PASSWORD
                  TextFormField(
                    controller: _konfirmasiPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Konfirmasi Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BOTTOM NAVIGATION
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : _saveUser, // Disabled saat loading
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? "Menyimpan..." : "Update User"),
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
        ),


      ],
    );
  }
}
