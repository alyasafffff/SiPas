import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapor_app/src/core/models/laporan_model.dart';
import 'package:lapor_app/src/features/laporan/application/laporan_controller.dart';

class UpdateLaporanScreen extends ConsumerStatefulWidget {
  final Laporan laporan;
  const UpdateLaporanScreen({super.key, required this.laporan});

  @override
  ConsumerState<UpdateLaporanScreen> createState() => _UpdateLaporanScreenState();
}

class _UpdateLaporanScreenState extends ConsumerState<UpdateLaporanScreen> {
  late final TextEditingController _deskripsiController;
  final ImagePicker _picker = ImagePicker();
  final List<File> _fotoAfterBaru = [];

  @override
  void initState() {
    super.initState();
    _deskripsiController = TextEditingController(text: widget.laporan.deskripsi);
  }

  @override
  void dispose() {
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pickImagesAfter() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _fotoAfterBaru.addAll(images.map((e) => File(e.path)));
      });
    }
  }

  Future<void> _handleUpdate() async {
    final success = await ref.read(laporanControllerProvider.notifier).updateLaporan(
      laporanId: widget.laporan.laporanId,
      deskripsi: _deskripsiController.text,
    );
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Laporan berhasil diperbarui")),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final laporanState = ref.watch(laporanControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Update Laporan")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Judul tidak bisa diedit
          TextFormField(
            initialValue: widget.laporan.judul,
            enabled: false,
            decoration: const InputDecoration(
              labelText: "Judul Laporan",
              border: OutlineInputBorder(),
              filled: true,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _deskripsiController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: "Deskripsi",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Foto Sebelum (Tidak bisa diubah)", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // TODO: Tampilkan foto before dari URL
          const SizedBox(height: 16),
          const Text("Foto Sesudah", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _pickImagesAfter,
            icon: const Icon(Icons.camera_alt),
            label: const Text("Tambah Foto Sesudah"),
          ),
          // TODO: Tampilkan preview foto after yang baru & lama
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: laporanState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton.icon(
                onPressed: _handleUpdate,
                icon: const Icon(Icons.save),
                label: const Text("Simpan Perubahan"),
              ),
      ),
    );
  }
}