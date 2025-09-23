class Laporan {
  final String laporanId;
  final String judul;
  final String deskripsi;
  final String idPelapor;
  final String status;
  final DateTime tanggalDibuat;
  final DateTime? tanggalSelesai;
  final String linkFotoBefore; // URL ke folder GDrive
  final String? linkFotoAfter; // URL ke folder GDrive

  Laporan({
    required this.laporanId,
    required this.judul,
    required this.deskripsi,
    required this.idPelapor,
    required this.status,
    required this.tanggalDibuat,
    this.tanggalSelesai,
    required this.linkFotoBefore,
    this.linkFotoAfter,
  });
}