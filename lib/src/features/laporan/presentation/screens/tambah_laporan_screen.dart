import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapor_app/src/features/laporan/application/laporan_controller.dart';

class TambahLaporanScreen extends ConsumerStatefulWidget {
  const TambahLaporanScreen({super.key});

  @override
  ConsumerState<TambahLaporanScreen> createState() => _TambahLaporanScreenState();
}

class _TambahLaporanScreenState extends ConsumerState<TambahLaporanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final List<File> _fotoBefore = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _fotoBefore.addAll(images.map((e) => File(e.path)));
      });
    }
  }

  Future<void> _handleSimpanLaporan() async {
    if (_formKey.currentState!.validate()) {
      if (_fotoBefore.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto Before wajib diupload")),
        );
        return;
      }

      final success = await ref.read(laporanControllerProvider.notifier).addLaporan(
            judul: _judulController.text,
            deskripsi: _deskripsiController.text,
            fotoBefore: _fotoBefore,
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Laporan berhasil ditambahkan")),
        );
        Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pantau state untuk menampilkan loading pada tombol simpan
    final laporanState = ref.watch(laporanControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Laporan")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: "Judul Laporan",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? "Judul tidak boleh kosong" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _deskripsiController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? "Deskripsi tidak boleh kosong" : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Upload Foto Before"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Widget untuk menampilkan preview gambar yang dipilih
            _buildImagePreview(),
          ],
        ),
      ),
      // Tombol Simpan di bawah
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: laporanState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton.icon(
              onPressed: _handleSimpanLaporan,
              icon: const Icon(Icons.save),
              label: const Text("Simpan Laporan"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_fotoBefore.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _fotoBefore.asMap().entries.map((entry) {
        final index = entry.key;
        final file = entry.value;
        return Stack(
          children: [
            Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
            Positioned(
              top: -4,
              right: -4,
              child: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _fotoBefore.removeAt(index);
                  });
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}