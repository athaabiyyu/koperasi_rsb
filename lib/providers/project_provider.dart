// lib/providers/project_provider.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/project_service.dart';

enum ProjectStatus { idle, loading, success, error }

class ProjectProvider extends ChangeNotifier {
  final ProjectService _projectService = ProjectService();

  ProjectStatus _status = ProjectStatus.idle;
  String? _errorMessage;
  ProjectResponse? _response;
  List<ProjectCategory> _categories = [];
  bool _isCategoriesLoading = false;

  // Form data storage
  Map<String, dynamic> _formData = {};
  List<File> _dokumenFiles = [];
  File? _brosurProdukFile;
  File? _dokumenProyeksiFile;

  // Getters
  ProjectStatus get status => _status;
  String? get errorMessage => _errorMessage;
  ProjectResponse? get response => _response;
  List<ProjectCategory> get categories => _categories;
  bool get isCategoriesLoading => _isCategoriesLoading;
  Map<String, dynamic> get formData => _formData;
  List<File> get dokumenFiles => _dokumenFiles;
  File? get brosurProdukFile => _brosurProdukFile;
  File? get dokumenProyeksiFile => _dokumenProyeksiFile;

  // Load categories from API
 Future<void> loadCategories() async {
  if (_categories.isNotEmpty) {
    return;
  }

  try {
    _isCategoriesLoading = true;
    notifyListeners();

    _categories = await _projectService.getProjectCategories();
    for (var cat in _categories) {
      print('  - "${cat.name}" (ID: ${cat.id}) [Length: ${cat.name.length}]');
    }
    
    // ✅ Check for empty names
    final emptyNames = _categories.where((c) => c.name.trim().isEmpty);
    if (emptyNames.isNotEmpty) {
    }

    _isCategoriesLoading = false;
    notifyListeners();
  } catch (e) {
    _isCategoriesLoading = false;
    _errorMessage = 'Gagal memuat kategori: ${e.toString()}';
    notifyListeners();
  }
}
  // Update form data untuk setiap section
  void updateFormData(String key, dynamic value) {
    _formData[key] = value;
    notifyListeners();
  }

  void updateMultipleFormData(Map<String, dynamic> data) {
    _formData.addAll(data);
    notifyListeners();
  }

  // File management
  void addDokumenFile(File file) {
    _dokumenFiles.add(file);
    notifyListeners();
  }

  void removeDokumenFile(int index) {
    if (index >= 0 && index < _dokumenFiles.length) {
      _dokumenFiles.removeAt(index);
      notifyListeners();
    }
  }

  void setBrosurProdukFile(File? file) {
    _brosurProdukFile = file;
    notifyListeners();
  }

  void setDokumenProyeksiFile(File? file) {
    _dokumenProyeksiFile = file;
    notifyListeners();
  }

  // Create project with detailed debugging
 Future<bool> createProject() async {
  try {
    _status = ProjectStatus.loading;
    _errorMessage = null;
    notifyListeners();

    _formData.forEach((key, value) {
    });
    for (int i = 0; i < _dokumenFiles.length; i++) {
    }

    if (_dokumenProyeksiFile == null) {
      throw Exception('Dokumen proyeksi wajib diupload');
    }
    
    final idKategori = _formData['id_kategori'] ?? '';
    final judul = _formData['judul'] ?? '';
    final deskripsi = _formData['deskripsi'] ?? '';
    final nominalStr = _formData['nominal']?.toString() ?? '0';
    final nominal = int.tryParse(nominalStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final assetJaminan = _formData['asset_jaminan'] ?? '';
    final nilaiJaminanStr = _formData['nilai_jaminan']?.toString() ?? '0';
    final nilaiJaminan = int.tryParse(nilaiJaminanStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0; 
    final lokasiUsaha = _formData['lokasi_usaha'] ?? '';
    final detailLokasi = _formData['detail_lokasi'] ?? '';
    final pendapatanStr = _formData['pendapatan_perbulan']?.toString() ?? '0';
    final pendapatanPerbulan = int.tryParse(pendapatanStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final pengeluaranStr = _formData['pengeluaran_perbulan']?.toString() ?? '0';
    final pengeluaranPerbulan = int.tryParse(pengeluaranStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final limitSiklusStr = _formData['limit_siklus']?.toString() ?? '0';
    final limitSiklus = int.tryParse(limitSiklusStr) ?? 0;
    
    // ✅ UBAH BAGIAN INI - Parse sebagai INT bukan DOUBLE
    final bagianPelaksanaStr = _formData['bagian_pelaksana']?.toString() ?? '0';
    final bagianPelaksana = int.tryParse(bagianPelaksanaStr) ?? 0;  // ✅ int.tryPars
    final bagianKoperasiStr = _formData['bagian_koperasi']?.toString() ?? '0';
    final bagianKoperasi = int.tryParse(bagianKoperasiStr) ?? 0;  // ✅ int.tryParse
    final bagianPemilikStr = _formData['bagian_pemilik']?.toString() ?? '0';
    final bagianPemilik = int.tryParse(bagianPemilikStr) ?? 0;  // ✅ int.tryParse
    final bagianPendanaStr = _formData['bagian_pendana']?.toString() ?? '0';
    final bagianPendana = int.tryParse(bagianPendanaStr) ?? 0;  // ✅ int.tryParse

    final validationErrors = <String>[];
    if (idKategori.isEmpty) validationErrors.add('ID Kategori kosong');
    if (judul.isEmpty) validationErrors.add('Judul kosong');
    if (deskripsi.isEmpty) validationErrors.add('Deskripsi kosong');
    if (nominal <= 0) validationErrors.add('Nominal tidak valid: $nominal');
    if (assetJaminan.isEmpty) validationErrors.add('Asset Jaminan kosong');
    if (nilaiJaminan <= 0) validationErrors.add('Nilai Jaminan tidak valid: $nilaiJaminan');
    if (lokasiUsaha.isEmpty) validationErrors.add('Lokasi Usaha kosong');
    if (detailLokasi.isEmpty) validationErrors.add('Detail Lokasi kosong');
    if (pendapatanPerbulan <= 0) validationErrors.add('Pendapatan tidak valid: $pendapatanPerbulan');
    if (pengeluaranPerbulan <= 0) validationErrors.add('Pengeluaran tidak valid: $pengeluaranPerbulan');
    if (limitSiklus <= 0) validationErrors.add('Limit Siklus tidak valid: $limitSiklus');
    
    if (validationErrors.isNotEmpty) {
      for (var error in validationErrors) {
      }
      throw Exception('Validation failed: ${validationErrors.join(", ")}');
    }

    // Build request object
    final request = CreateProjectRequest(
      idKategori: idKategori,
      judul: judul,
      deskripsi: deskripsi,
      nominal: nominal,
      assetJaminan: assetJaminan,
      nilaiJaminan: nilaiJaminan,
      lokasiUsaha: lokasiUsaha,
      detailLokasi: detailLokasi,
      pendapatanPerbulan: pendapatanPerbulan,
      pengeluaranPerbulan: pengeluaranPerbulan,
      limitSiklus: limitSiklus,
      bagianPelaksana: bagianPelaksana,  // ✅ Sekarang int
      bagianKoperasi: bagianKoperasi,    // ✅ Sekarang int
      bagianPemilik: bagianPemilik,      // ✅ Sekarang int
      bagianPendana: bagianPendana,      // ✅ Sekarang int
      dokumenProyeksi: _dokumenProyeksiFile!.path,
    );
    print('  Request object created ✓');

    // Call service
    print('\n🚀 Calling Project Service...');
    _response = await _projectService.createProject(
      project: request,
      dokumenFiles: _dokumenFiles.isNotEmpty ? _dokumenFiles : null,
      brosurProdukFile: _brosurProdukFile,
      dokumenProyeksiFile: _dokumenProyeksiFile!,
    );
    
    _status = ProjectStatus.success;
    notifyListeners();

    clearFormData();
    
    return true;
    
  } catch (e) {
    
    _status = ProjectStatus.error;
    _errorMessage = e.toString().replaceAll('Exception: ', '');
    notifyListeners();
    

    return false;
  }
}
  // Save draft
  Future<void> saveDraft() async {
    try {
      await _projectService.saveDraft(_formData);
    } catch (e) {
      _errorMessage = 'Gagal menyimpan draft: ${e.toString()}';
      notifyListeners();
    }
  }

  // Load draft
  Future<void> loadDraft() async {
    try {
      final draft = await _projectService.getDraft();
      if (draft != null) {
        _formData = draft;
        notifyListeners();
      } else {
      }
    } catch (e) {
      _errorMessage = 'Gagal memuat draft: ${e.toString()}';
      notifyListeners();
    }
  }

  // Clear all form data
  void clearFormData() {
    _formData.clear();
    _dokumenFiles.clear();
    _brosurProdukFile = null;
    _dokumenProyeksiFile = null;
    _status = ProjectStatus.idle;
    _errorMessage = null;
    _response = null;
    notifyListeners();
  }

  // Validate percentage total (should be 100%)
  bool validatePercentages() {
  final pelaksana = int.tryParse(_formData['bagian_pelaksana']?.toString() ?? '0') ?? 0;
  final koperasi = int.tryParse(_formData['bagian_koperasi']?.toString() ?? '0') ?? 0;
  final pemilik = int.tryParse(_formData['bagian_pemilik']?.toString() ?? '0') ?? 0;
  final pendana = int.tryParse(_formData['bagian_pendana']?.toString() ?? '0') ?? 0;

  final total = pelaksana + koperasi + pemilik + pendana;
  final isValid = total == 100; // ✅ Exact match karena sekarang integer
  
  return isValid;
}

String getPercentageTotal() {
  final pelaksana = int.tryParse(_formData['bagian_pelaksana']?.toString() ?? '0') ?? 0;
  final koperasi = int.tryParse(_formData['bagian_koperasi']?.toString() ?? '0') ?? 0;
  final pemilik = int.tryParse(_formData['bagian_pemilik']?.toString() ?? '0') ?? 0;
  final pendana = int.tryParse(_formData['bagian_pendana']?.toString() ?? '0') ?? 0;

  return (pelaksana + koperasi + pemilik + pendana).toString();
}

  // Reset status
  void resetStatus() {
    _status = ProjectStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
}