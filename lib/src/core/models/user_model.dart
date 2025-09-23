class User {
  final String userId;
  final String nama;
  final String email;
  final String role;
  final String jabatan;
  final String nomorHp;
  final String fotoProfilUrl;
  final DateTime tanggalDibuat;

  User({
    required this.userId,
    required this.nama,
    required this.email,
    required this.role,
    required this.jabatan,
    required this.nomorHp,
    required this.fotoProfilUrl,
    required this.tanggalDibuat,
  });
}