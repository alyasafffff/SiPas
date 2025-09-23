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

   factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'].toString(),
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'Staff',
      jabatan: json['jabatan'] ?? '',
      nomorHp: json['nomor_hp'].toString(),
      fotoProfilUrl: json['link_foto_profil'] ?? '',
      tanggalDibuat: DateTime.parse(json['tanggal_dibuat']),
    );
  }
}