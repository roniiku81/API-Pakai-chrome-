import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/siswa.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/siswa';

  static Future<List<Siswa>> getSiswa() async {
    final response = await http.get(Uri.parse(baseUrl));
    final List data = jsonDecode(response.body);
    return data.map((e) => Siswa.fromJson(e)).toList();
  }

  static Future<void> tambahSiswa(Map<String, dynamic> data) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<void> hapusSiswa(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
