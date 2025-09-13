import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateLaporanPage extends StatefulWidget {
  final String id;
  final String judul;
  final String deskripsi;
  final List<String> fotoBefore; // multiple foto before lama
  final List<String>? fotoAfter; // multiple foto after lama
  final String status;
  final String user;

  const UpdateLaporanPage({
    super.key,
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.fotoBefore,
    this.fotoAfter,
    required this.status,
    required this.user,
  });

  @override
  State<UpdateLaporanPage> createState() => _UpdateLaporanPageState();
}

class _UpdateLaporanPageState extends State<UpdateLaporanPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;

  final ImagePicker _picker = ImagePicker();
  List<File> _fotoAfterBaru = []; // foto after baru

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.judul);
    _deskripsiController = TextEditingController(text: widget.deskripsi);
  }

  Future<void> _pickMultipleAfter() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _fotoAfterBaru.addAll(images.map((x) => File(x.path)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color appBarColor = Color(0xFF0E2148);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Update Laporan"),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Judul
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: "Judul Laporan",
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 12),

              // Deskripsi
              TextFormField(
                controller: _deskripsiController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Foto Before (hanya preview, tidak bisa upload)
              const Text(
                "Kondisi Sebelum Perbaikan",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (widget.fotoBefore.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.fotoBefore
                      .map(
                        (path) => Image.asset(
                          path,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                      .toList(),
                )
              else
                const Text("Belum ada foto before."),
              const SizedBox(height: 16),

              // Upload Foto After
              const Text(
                "Upload Foto Sesudah Perbaikan",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),

              ElevatedButton.icon(
                onPressed: _pickMultipleAfter,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Pilih Foto After"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: const Color.fromARGB(221, 59, 59, 59),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Preview Foto After (lama + baru)
              Builder(
                builder: (_) {
                  List<Widget> previews = [];

                  // Foto After Lama
                  if (widget.fotoAfter != null &&
                      widget.fotoAfter!.isNotEmpty) {
                    previews.addAll(
                      widget.fotoAfter!.asMap().entries.map((entry) {
                        final i = entry.key;
                        final path = entry.value;
                        return Stack(
                          children: [
                            Image.asset(
                              path,
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
                                    widget.fotoAfter!.removeAt(
                                      i,
                                    ); // hapus foto lama
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    );
                  }

                  // Foto After Baru
                  if (_fotoAfterBaru.isNotEmpty) {
                    previews.addAll(
                      _fotoAfterBaru.asMap().entries.map((entry) {
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
                                    _fotoAfterBaru.removeAt(
                                      i,
                                    ); // hapus foto baru
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    );
                  }

                  if (previews.isEmpty) {
                    return const Text("Belum ada foto after.");
                  }

                  return Wrap(spacing: 8, runSpacing: 8, children: previews);
                },
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Laporan berhasil diupdate")),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            icon: const Icon(Icons.save),
            label: const Text("Update Laporan"),
          ),
        ),
      ),
    );
  }
}
