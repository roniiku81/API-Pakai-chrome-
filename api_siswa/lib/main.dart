import 'package:flutter/material.dart';
import 'api_service.dart';
import 'siswa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Siswa Management',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5), // Biru Profesional
          brightness: Brightness.light,
        ),
      ),
      home: const SiswaPage(),
    );
  }
}

class SiswaPage extends StatefulWidget {
  const SiswaPage({super.key});

  @override
  State<SiswaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends State<SiswaPage> {
  late Future<List<Siswa>> siswaFuture;

  @override
  void initState() {
    super.initState();
    siswaFuture = ApiService.getSiswa();
  }

  void refresh() {
    setState(() {
      siswaFuture = ApiService.getSiswa();
    });
  }

  // --- UI Komponen: Form Dialog ---
  void showFormDialog({Siswa? siswa}) {
    final isEdit = siswa != null;
    final namaController = TextEditingController(text: isEdit ? siswa.nama : '');
    final nisnController = TextEditingController(text: isEdit ? siswa.nisn : '');
    final jurusanController = TextEditingController(text: isEdit ? siswa.jurusan : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(isEdit ? 'Edit Data Siswa' : 'Tambah Siswa Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(namaController, 'Nama Lengkap', Icons.person),
              const SizedBox(height: 12),
              _buildTextField(nisnController, 'NISN', Icons.badge),
              const SizedBox(height: 12),
              _buildTextField(jurusanController, 'Jurusan', Icons.school),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              final data = {
                "nama": namaController.text,
                "nisn": nisnController.text,
                "jurusan": jurusanController.text,
              };
              if (isEdit) {
                await ApiService.updateSiswa(siswa.id, data);
              } else {
                await ApiService.addSiswa(data);
              }
              Navigator.pop(context);
              refresh();
            },
            child: Text(isEdit ? 'Update' : 'Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Data Siswa', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: RefreshIndicator(
        onRefresh: () async => refresh(),
        child: FutureBuilder<List<Siswa>>(
          future: siswaFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final s = snapshot.data![index];
                return _buildSiswaCard(s);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showFormDialog(),
        label: const Text('Tambah Siswa'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSiswaCard(Siswa s) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(s.nama[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
        ),
        title: Text(s.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('NISN: ${s.nisn}'),
            Text('Jurusan: ${s.jurusan}', style: TextStyle(color: Colors.blueGrey[600])),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') {
              showFormDialog(siswa: s);
            } else if (value == 'delete') {
              _confirmDelete(s);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
            const PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Hapus'))),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Siswa s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data?'),
        content: Text('Apakah Anda yakin ingin menghapus ${s.nama}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              await ApiService.deleteSiswa(s.id);
              Navigator.pop(context);
              refresh();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('Belum ada data siswa', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
        ],
      ),
    );
  }
}