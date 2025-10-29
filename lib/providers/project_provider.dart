import 'dart:io';
import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/project_service.dart';
import '../services/history_project_service.dart';
import '../models/project_list_model.dart';
import '../models/agreement_model.dart';
import '../models/history_project_model.dart';


enum ProjectStatus { idle, loading, success, error }

class ProjectProvider extends ChangeNotifier {
  final ProjectService _projectService = ProjectService();
  final HistoryProjectService _historyProjectService = HistoryProjectService();

  ProjectStatus _status = ProjectStatus.idle;
  String? _errorMessage;
  ProjectResponse? _response;
  List<ProjectCategory> _categories = [];
  bool _isCategoriesLoading = false;
  List<ProjectListItem> _userProjects = [];
  bool _isLoadingProjects = false;
  String? _projectsError;
  
  // Project detail state
  ProjectListItem? _projectDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  // Agreement letter state
  AgreementLetter? _agreementLetter;
  bool _isLoadingAgreement = false;
  String? _agreementError;

  // History project state
  List<HistoryProject> _projectHistories = [];
  bool _isLoadingHistory = false;
  String? _historyError;

  // Form data storage
  Map<String, dynamic> _formData = {};
  List<File> _dokumenFiles = [];
  File? _brosurProdukFile;
  File? _dokumenProyeksiFile;

  // Getters
  ProjectStatus get status => _status;
  String? get errorMessage => _errorMessage;
  ProjectResponse? get response => _response;
  List<ProjectListItem> get userProjects => _userProjects;
  bool get isLoadingProjects => _isLoadingProjects;
  String? get projectsError => _projectsError;
  List<ProjectCategory> get categories => _categories;
  bool get isCategoriesLoading => _isCategoriesLoading;
  Map<String, dynamic> get formData => _formData;
  List<File> get dokumenFiles => _dokumenFiles;
  File? get brosurProdukFile => _brosurProdukFile;
  File? get dokumenProyeksiFile => _dokumenProyeksiFile;
  
  // Project detail getters
  ProjectListItem? get projectDetail => _projectDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  // Agreement letter getters
  AgreementLetter? get agreementLetter => _agreementLetter;
  bool get isLoadingAgreement => _isLoadingAgreement;
  String? get agreementError => _agreementError;

  // History project getters
  List<HistoryProject> get projectHistories => _projectHistories;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get historyError => _historyError;

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

  // Get project detail
  Future<ProjectListItem> getProjectDetail(String projectId) async {
    try {
      _isLoadingDetail = true;
      _detailError = null;
      notifyListeners();

      print('📡 Loading project detail: $projectId');
      
      final detail = await _projectService.getProjectDetail(projectId);
      
      _projectDetail = detail;
      _isLoadingDetail = false;
      notifyListeners();
      
      print('✅ Project detail loaded successfully');
      return detail;
      
    } catch (e) {
      print('❌ Error loading project detail: $e');
      _isLoadingDetail = false;
      _detailError = e.toString().replaceAll('Exception: ', '');
      _projectDetail = null;
      notifyListeners();
      rethrow;
    }
  }

  // Clear project detail cache
  void clearProjectDetail() {
    _projectDetail = null;
    _isLoadingDetail = false;
    _detailError = null;
    notifyListeners();
  }

  /// Load agreement letter for a project
  Future<void> loadAgreementLetter(String projectId) async {
    try {
      _isLoadingAgreement = true;
      _agreementError = null;
      notifyListeners();

      print('📡 Loading agreement letter for project: $projectId');
      
      final agreement = await _projectService.getAgreementByProjectId(projectId);
      
      _agreementLetter = agreement;
      _isLoadingAgreement = false;
      notifyListeners();
      
      if (agreement != null) {
        print('✅ Agreement letter loaded successfully');
      } else {
        print('ℹ️ No agreement letter found');
      }
      
    } catch (e) {
      print('❌ Error loading agreement letter: $e');
      _isLoadingAgreement = false;
      _agreementError = e.toString().replaceAll('Exception: ', '');
      _agreementLetter = null;
      notifyListeners();
    }
  }

  /// Clear agreement letter cache
  void clearAgreementLetter() {
    _agreementLetter = null;
    _isLoadingAgreement = false;
    _agreementError = null;
    notifyListeners();
  }

  /// Check if agreement exists for current project
  bool hasAgreementLetter() {
    return _agreementLetter != null;
  }

  /// Load project history
  Future<void> loadProjectHistory(String projectId) async {
    try {
      _isLoadingHistory = true;
      _historyError = null;
      notifyListeners();

      print('📡 Loading project history for: $projectId');
      
      final histories = await _historyProjectService.getProjectHistory(projectId);
      
      _projectHistories = histories;
      _isLoadingHistory = false;
      notifyListeners();
      
      print('✅ Loaded ${histories.length} history items');
      
    } catch (e) {
      print('❌ Error loading project history: $e');
      _isLoadingHistory = false;
      _historyError = e.toString().replaceAll('Exception: ', '');
      _projectHistories = [];
      notifyListeners();
    }
  }

  /// Get timeline steps with grouped histories
  List<TimelineStepData> getTimelineSteps() {
    return _historyProjectService.groupHistoriesByStep(_projectHistories);
  }

  /// Clear project history cache
  void clearProjectHistory() {
    _projectHistories.clear();
    _isLoadingHistory = false;
    _historyError = null;
    notifyListeners();
  }

  /// Check if project has any history
  bool hasProjectHistory() {
    return _projectHistories.isNotEmpty;
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
      
      final bagianPelaksanaStr = _formData['bagian_pelaksana']?.toString() ?? '0';
      final bagianPelaksana = int.tryParse(bagianPelaksanaStr) ?? 0;
      final bagianKoperasiStr = _formData['bagian_koperasi']?.toString() ?? '0';
      final bagianKoperasi = int.tryParse(bagianKoperasiStr) ?? 0;
      final bagianPemilikStr = _formData['bagian_pemilik']?.toString() ?? '0';
      final bagianPemilik = int.tryParse(bagianPemilikStr) ?? 0;
      final bagianPendanaStr = _formData['bagian_pendana']?.toString() ?? '0';
      final bagianPendana = int.tryParse(bagianPendanaStr) ?? 0;

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
        bagianPelaksana: bagianPelaksana,
        bagianKoperasi: bagianKoperasi,
        bagianPemilik: bagianPemilik,
        bagianPendana: bagianPendana,
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

  // Load user projects with filter
  Future<void> loadUserProjects({String? status, String? search}) async {
    try {
      _isLoadingProjects = true;
      _projectsError = null;
      notifyListeners();

      _userProjects = await _projectService.getUserProjects(
        status: status,
        search: search,
      );

      _isLoadingProjects = false;
      notifyListeners();
    } catch (e) {
      _isLoadingProjects = false;
      _projectsError = e.toString().replaceAll('Exception: ', '');
      _userProjects = [];
      notifyListeners();
    }
  }

  // Get projects count by status
  int getProjectCountByStatus(String status) {
    return _userProjects.where((p) => p.status == status).length;
  }

  // Get projects count by multiple statuses
  int getProjectCountByStatuses(List<String> statuses) {
    return _userProjects.where((p) => statuses.contains(p.status)).length;
  }

  // Get projects by status with sorting
  List<ProjectListItem> getProjectsByStatus(String status, {bool newest = true}) {
    var filtered = _userProjects.where((p) => p.status == status).toList();
    
    if (newest) {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    
    return filtered;
  }

  // Get projects by multiple statuses with sorting
  List<ProjectListItem> getProjectsByStatuses(List<String> statuses, {bool newest = true}) {
    var filtered = _userProjects.where((p) => statuses.contains(p.status)).toList();
    
    if (newest) {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    
    return filtered;
  }

  // Clear projects cache
  void clearProjectsCache() {
    _userProjects.clear();
    _isLoadingProjects = false;
    _projectsError = null;
    notifyListeners();
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
    final isValid = total == 100;
    
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