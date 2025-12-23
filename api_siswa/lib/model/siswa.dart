class Siswa {
  final int id;
  final String nisn;
  final String nama;
  final String jurusan;

  Siswa({
    required this.id,
    required this.nisn,
    required this.nama,
    required this.jurusan,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: json['id'],
      nisn: json['nisn'],
      nama: json['nama'],
      jurusan: json['jurusan'],
    );
  }
}
