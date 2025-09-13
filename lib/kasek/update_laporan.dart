// update_laporan_kasek.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateLaporanPageKasek extends StatefulWidget {
  final String id;
  final String judul;
  final String deskripsi;
  final List<String> fotoBefore; // list (asset/url)
  final List<String>? fotoAfter; // list (asset/url)
  final String status;
  final String user;

  const UpdateLaporanPageKasek({
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
  State<UpdateLaporanPageKasek> createState() => _UpdateLaporanPageState();
}

class _UpdateLaporanPageState extends State<UpdateLaporanPageKasek> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;

  final ImagePicker _picker = ImagePicker();

  // foto bawaan (asset/url)
  List<String> _fotoBeforeDefault = [];
  List<String> _fotoAfterDefault = [];

  // foto baru (File lokal)
  List<File> _fotoBeforeFiles = [];
  List<File> _fotoAfterFiles = [];

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.judul);
    _deskripsiController = TextEditingController(text: widget.deskripsi);

    _fotoBeforeDefault = List<String>.from(widget.fotoBefore);
    if (widget.fotoAfter != null && widget.fotoAfter!.isNotEmpty) {
      _fotoAfterDefault = List<String>.from(widget.fotoAfter!);
    }
  }

  Future<void> _pickImagesBefore() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _fotoBeforeFiles.addAll(images.map((x) => File(x.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih foto before: $e')),
      );
    }
  }

  Future<void> _pickImagesAfter() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _fotoAfterFiles.addAll(images.map((x) => File(x.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih foto after: $e')),
      );
    }
  }

  bool _isNetworkPath(String p) {
    return p.startsWith('http://') || p.startsWith('https://');
  }

  Widget _buildPreviewFromPath(String path) {
    if (_isNetworkPath(path)) {
      return Image.network(path, fit: BoxFit.cover, width: 120, height: 120);
    } else {
      return Image.asset(path, fit: BoxFit.cover, width: 120, height: 120);
    }
  }

  // ganti ukuran di _buildFotoGrid
Widget _buildFotoGrid({
  required List<String> defaultList,
  required List<File> fileList,
  required Function(int) onRemoveDefault,
  required Function(int) onRemoveFile,
}) {
  final List<Widget> items = [];

  // Default (asset/url)
  for (int i = 0; i < defaultList.length; i++) {
    final path = defaultList[i];
    items.add(Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 100,  // ubah jadi 100
            height: 100, // ubah jadi 100
            child: _buildPreviewFromPath(path),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => onRemoveDefault(i),
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.red,
              child: Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    ));
  }

  // Files (baru)
  for (int i = 0; i < fileList.length; i++) {
    final file = fileList[i];
    items.add(Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 100,  // ubah jadi 100
            height: 100, // ubah jadi 100
            child: Image.file(file, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => onRemoveFile(i),
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.red,
              child: Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    ));
  }

  if (items.isEmpty) {
    return const Text("Belum ada foto");
  }

  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: items,
  );
}


  @override
  Widget build(BuildContext context) {
    const Color appBarColor = Color(0xFF0E2148);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Laporan"),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
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

              // Foto Before
              const Text(
                "Foto Sebelum Perbaikan",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImagesBefore,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Tambah Foto Before"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: const Color.fromARGB(221, 59, 59, 59),
                ),
              ),
              const SizedBox(height: 8),
              _buildFotoGrid(
                defaultList: _fotoBeforeDefault,
                fileList: _fotoBeforeFiles,
                onRemoveDefault: (i) {
                  setState(() => _fotoBeforeDefault.removeAt(i));
                },
                onRemoveFile: (i) {
                  setState(() => _fotoBeforeFiles.removeAt(i));
                },
              ),
              const SizedBox(height: 16),

              // Foto After
              const Text(
                "Foto Sesudah Perbaikan",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImagesAfter,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Tambah Foto After"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: const Color.fromARGB(221, 59, 59, 59),
                ),
              ),
              const SizedBox(height: 8),
              _buildFotoGrid(
                defaultList: _fotoAfterDefault,
                fileList: _fotoAfterFiles,
                onRemoveDefault: (i) {
                  setState(() => _fotoAfterDefault.removeAt(i));
                },
                onRemoveFile: (i) {
                  setState(() => _fotoAfterFiles.removeAt(i));
                },
              ),
            ],
          ),
        ),
      ),

      // Tombol Update
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Update Laporan"),
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                     "berhasil di edit"
                    ),
                  ),
                );

                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
    );
  }
}
