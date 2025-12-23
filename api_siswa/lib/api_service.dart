import 'dart:convert';
import 'package:http/http.dart' as http;
import 'siswa.dart';

class ApiService {
  // Gunakan 127.0.0.1 untuk Chrome. 
  // Jika pakai Emulator Android, ganti ke 10.0.2.2
  static const String baseUrl = 'http://127.0.0.1:8080/siswa';

    


  // GET DATA
  static Future<List<Siswa>> getSiswa() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Siswa.fromJson(data)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  // ADD DATA (POST)
  static Future<void> addSiswa(Map<String, dynamic> data) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }


  // Tambahkan di dalam class ApiService
    static Future<void> updateSiswa(int id, Map<String, dynamic> data) async {
    final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
        throw Exception('Gagal mengupdate data');
    }
    }

  // DELETE DATA
  static Future<void> deleteSiswa(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}