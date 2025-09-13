import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahLaporanPage extends StatefulWidget {
  const TambahLaporanPage({super.key});

  @override
  State<TambahLaporanPage> createState() => _TambahLaporanPageState();
}

class _TambahLaporanPageState extends State<TambahLaporanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  List<File> _fotoBefore = [];
  List<File> _fotoAfter = [];

  bool _selfHandled = false;

  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk pilih foto
  Future<void> _pickImages(bool isBefore) async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        if (isBefore) {
          _fotoBefore.addAll(images.map((e) => File(e.path)));
        } else {
          _fotoAfter.addAll(images.map((e) => File(e.path)));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tambah Laporan"),
        backgroundColor: const Color(0xFF0E2148),
        iconTheme: const IconThemeData(
          color: Colors.white, // warna ikon back
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white, // warna teks judul
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
              // Input Judul
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: "Judul Laporan",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Judul tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),

              // Input Deskripsi
              TextFormField(
                controller: _deskripsiController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Deskripsi tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),

              // Upload Foto Before
              ElevatedButton.icon(
                onPressed: () => _pickImages(true), // untuk foto Before

                icon: const Icon(Icons.camera_alt),
                label: const Text("Upload Foto Before"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200], // tombol terang
                  foregroundColor: const Color.fromARGB(
                    221,
                    59,
                    59,
                    59,
                  ), // teks & ikon gelap
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Preview Foto Before
              // Preview Foto Before
              if (_fotoBefore.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _fotoBefore.asMap().entries.map((entry) {
                    final i = entry.key;
                    final file = entry.value;
                    return Stack(
                      children: [
                        Image.file(
                          file,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _fotoBefore.removeAt(i); // hapus foto before
                              });
                            },
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              const SizedBox(height: 12),

              // Checkbox Self Handled
              CheckboxListTile(
                value: _selfHandled,
                onChanged: (val) => setState(() => _selfHandled = val!),
                title: const Text("Tangani dan Selesaikan"),
              ),

              // Upload Foto After muncul jika self handled dicentang
              if (_selfHandled) ...[
                ElevatedButton.icon(
                  onPressed: () => _pickImages(false), // untuk foto After
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Upload Foto After"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: const Color.fromARGB(221, 59, 59, 59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "⚠️ Upload foto After akan otomatis menandai laporan sebagai Selesai",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                // Preview Foto After (jika self handled)
                if (_selfHandled && _fotoAfter.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _fotoAfter.asMap().entries.map((entry) {
                      final i = entry.key;
                      final file = entry.value;
                      return Stack(
                        children: [
                          Image.file(
                            file,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _fotoAfter.removeAt(i); // hapus foto after
                                });
                              },
                              child: const CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
              ],
            ],
          ),
        ),
      ),

      // Tombol Simpan di bawah
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_fotoBefore.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Foto Before wajib diupload")),
                  );
                  return;
                }
                if (_selfHandled && _fotoAfter.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Foto After wajib diupload")),
                  );
                  return;
                }

                // ----- Simulasi simpan data -----
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Laporan berhasil disimpan")),
                );

                // ----- Tambah notifikasi -----
                // Bisa pakai Navigator untuk mengakses NotifikasiPage
                // atau gunakan state management / global key
                // contoh sederhana:
                // final notifikasiPageState = ...;
                // notifikasiPageState.tambahNotifikasi("Laporan baru: ${_judulController.text}");

                // Kembali ke halaman sebelumnya
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
            label: const Text("Simpan Laporan"),
          ),
        ),
      ),
    );
  }
}
