<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;

class Siswa extends ResourceController
{
    protected $modelName = 'App\Models\SiswaModel';
    protected $format    = 'json';

    // GET: Tampil semua data
    public function index()
    {
        return $this->respond($this->model->findAll());
    }

    // POST: Tambah data baru
    public function create()
    {
        $data = $this->request->getJSON(true); // Ambil data JSON dari Flutter
        if ($this->model->insert($data)) {
            return $this->respondCreated(['status' => 'success', 'message' => 'Data berhasil disimpan']);
        }
        return $this->fail('Gagal menyimpan data');
    }
    
    // Tambahkan fungsi ini di dalam class Siswa
public function update($id = null)
{
    $data = $this->request->getJSON(true); // Ambil data JSON terbaru dari Flutter
    
    // Cek apakah data dengan ID tersebut ada
    if (!$this->model->find($id)) {
        return $this->failNotFound('Data siswa tidak ditemukan');
    }

    if ($this->model->update($id, $data)) {
        return $this->respond(['status' => 'success', 'message' => 'Data berhasil diupdate']);
    }
    
    return $this->fail('Gagal mengupdate data');
}

    // DELETE: Hapus data
    public function delete($id = null)
    {
        if ($this->model->delete($id)) {
            return $this->respondDeleted(['status' => 'success', 'message' => 'Data berhasil dihapus']);
        }
        return $this->failNotFound('ID tidak ditemukan');
    }
}