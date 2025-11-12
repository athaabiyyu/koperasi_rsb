import 'dart:io';
import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/project_service.dart';
import '../services/history_project_service.dart';
import '../models/project_list_model.dart';
import '../models/agreement_model.dart';
import '../models/history_project_model.dart';
import '../models/project_investor_model.dart';

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
  // All projects state (public list)
  List<ProjectListItem> _allProjects = [];
  bool _isLoadingAllProjects = false;
  String? _allProjectsError;

  // Add update mode state
  String? _editingProjectId;
  bool _isUpdateMode = false;

  // Project detail state
  ProjectListItem? _projectDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  // Agreement letter state
  AgreementLetter? _agreementLetter;
  bool _isLoadingAgreement = false;
  String? _agreementError;

  // Sign agreement state
  bool _isSigningAgreement = false;
  String? _signAgreementError;

  // Project investors state
  List<InvestorSummary> _projectInvestors = [];
  bool _isLoadingInvestors = false;
  String? _investorsError;

  //Calculated token stats
  int _collectedToken = 0;
  int _remainingToken = 0;

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
  // All projects getters
  List<ProjectListItem> get allProjects => _allProjects;
  bool get isLoadingAllProjects => _isLoadingAllProjects;
  String? get allProjectsError => _allProjectsError;
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

  // Update mode getters
  bool get isUpdateMode => _isUpdateMode;
  String? get editingProjectId => _editingProjectId;

  // Agreement letter getters
  AgreementLetter? get agreementLetter => _agreementLetter;
  bool get isLoadingAgreement => _isLoadingAgreement;
  String? get agreementError => _agreementError;

  // Sign agreement getters
  bool get isSigningAgreement => _isSigningAgreement;
  String? get signAgreementError => _signAgreementError;

  // History project getters
  List<HistoryProject> get projectHistories => _projectHistories;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get historyError => _historyError;

  List<InvestorSummary> get projectInvestors => _projectInvestors;
  bool get isLoadingInvestors => _isLoadingInvestors;
  String? get investorsError => _investorsError;
  int get collectedToken => _collectedToken;
  int get remainingToken => _remainingToken;

  // Load categories from API
  Future<void> loadCategories() async {
    if (_categories.isNotEmpty) {
      return;
    }

    try {
      _isCategoriesLoading = true;
      notifyListeners();

      _categories = await _projectService.getProjectCategories();

      _isCategoriesLoading = false;
      notifyListeners();
    } catch (e) {
      _isCategoriesLoading = false;
      _errorMessage = 'Gagal memuat kategori: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> loadProjectInvestors(String projectId) async {
    try {
      _isLoadingInvestors = true;
      _investorsError = null;
      notifyListeners();

      print('\n📊 === LOADING PROJECT INVESTORS ===');
      print('Project ID: $projectId');

      final investors = await _projectService.getProjectInvestors(projectId);

      _projectInvestors = investors;

      // Calculate total collected tokens
      _collectedToken = investors.fold<int>(
        0,
        (sum, investor) => sum + investor.jumlahToken,
      );

      // Calculate remaining tokens (if project detail is loaded)
      if (_projectDetail != null && _projectDetail!.jumlahKoin != null) {
        _remainingToken = _projectDetail!.jumlahKoin! - _collectedToken;
      }

      _isLoadingInvestors = false;
      notifyListeners();

      print('✅ Loaded ${investors.length} investors');
      print('📈 Total collected tokens: $_collectedToken');
      print('📉 Remaining tokens: $_remainingToken');
    } catch (e) {
      _isLoadingInvestors = false;
      _investorsError = e.toString().replaceAll('Exception: ', '');
      _projectInvestors = [];
      _collectedToken = 0;
      _remainingToken = _projectDetail?.jumlahKoin ?? 0;
      notifyListeners();

      print('❌ Failed to load investors: $_investorsError');
    }
  }

  // Load project data for editing
  Future<void> loadProjectForEdit(String projectId) async {
    try {
      final project = await getProjectDetail(projectId);

      // Populate form data
      _formData = {
        'id_kategori': project.idKategori,
        'judul': project.judul,
        'deskripsi': project.deskripsi,
        'nominal': project.nominal.toString(),
        'asset_jaminan': project.assetJaminan,
        'nilai_jaminan': project.nilaiJaminan.toString(),
        'lokasi_usaha': project.lokasiUsaha,
        'detail_lokasi': project.detailLokasi,
        'pendapatan_perbulan': project.pendapatanPerbulan.toString(),
        'pengeluaran_perbulan': project.pengeluaranPerbulan.toString(),
        'limit_siklus': project.limitSiklus.toString(),
        'bagian_pelaksana': project.bagianPelaksana.toString(),
        'bagian_koperasi': project.bagianKoperasi.toString(),
        'bagian_pemilik': project.bagianPemilik.toString(),
        'bagian_pendana': project.bagianPendana.toString(),
        'brosur_produk': project.brosurProduk,
        'dokumen_proyeksi': project.dokumenProyeksi,
        'dokumen': project.dokumenTambahan ?? [],
      };

      _editingProjectId = projectId;
      _isUpdateMode = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Get project detail
  Future<ProjectListItem> getProjectDetail(String projectId) async {
    try {
      _isLoadingDetail = true;
      _detailError = null;
      notifyListeners();

      final detail = await _projectService.getProjectDetail(projectId);

      _projectDetail = detail;
      _isLoadingDetail = false;
      notifyListeners();

      // ✅ Automatically load investors after getting detail
      await loadProjectInvestors(projectId);

      return detail;
    } catch (e) {
      _isLoadingDetail = false;
      _detailError = e.toString().replaceAll('Exception: ', '');
      _projectDetail = null;
      notifyListeners();
      rethrow;
    }
  }

  void clearProjectInvestors() {
    _projectInvestors.clear();
    _isLoadingInvestors = false;
    _investorsError = null;
    _collectedToken = 0;
    _remainingToken = 0;
    notifyListeners();
  }

  // Clear project detail cache
  void clearProjectDetail() {
    _projectDetail = null;
    _isLoadingDetail = false;
    _detailError = null;
    clearProjectInvestors();
    notifyListeners();
  }

  double getFundingProgress() {
    if (_projectDetail == null || _projectDetail!.jumlahKoin == null) {
      return 0.0;
    }
    final maxToken = _projectDetail!.jumlahKoin!;
    if (maxToken == 0) return 0.0;
    return (_collectedToken / maxToken).clamp(0.0, 1.0);
  }

  String getFundingProgressText() {
    final progress = getFundingProgress() * 100;
    return '${progress.toStringAsFixed(1)}%';
  }

  /// Load agreement letter for a project
  Future<void> loadAgreementLetter(String projectId) async {
    try {
      _isLoadingAgreement = true;
      _agreementError = null;
      notifyListeners();

      final agreement = await _projectService.getAgreementByProjectId(
        projectId,
      );

      _agreementLetter = agreement;
      _isLoadingAgreement = false;
      notifyListeners();
    } catch (e) {
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

      final histories = await _historyProjectService.getProjectHistory(
        projectId,
      );

      _projectHistories = histories;
      _isLoadingHistory = false;
      notifyListeners();
    } catch (e) {
      _isLoadingHistory = false;
      _historyError = e.toString().replaceAll('Exception: ', '');
      _projectHistories = [];
      notifyListeners();
    }
  }

  // Update existing project
  Future<bool> updateProject() async {
  if (_editingProjectId == null) {
    _errorMessage = 'ID project tidak ditemukan';
    return false;
  }

  try {
    _status = ProjectStatus.loading;
    _errorMessage = null;
    notifyListeners();

    print('\n🔄 === UPDATE PROJECT PROVIDER ===');
    print('Project ID: $_editingProjectId');
    print('Form Data: $_formData');

    // ✅ PERBAIKAN: Validasi - dokumen proyeksi bisa dari file baru ATAU existing
    final hasNewDokumenProyeksi = _dokumenProyeksiFile != null;
    final hasExistingDokumenProyeksi = _formData['dokumen_proyeksi'] != null && 
                                        _formData['dokumen_proyeksi'].toString().isNotEmpty;
    
    if (!hasNewDokumenProyeksi && !hasExistingDokumenProyeksi) {
      throw Exception('Dokumen proyeksi wajib ada');
    }

    print('📄 Dokumen Proyeksi Status:');
    print('  - New file: ${hasNewDokumenProyeksi ? _dokumenProyeksiFile!.path : "None"}');
    print('  - Existing: ${hasExistingDokumenProyeksi ? _formData['dokumen_proyeksi'] : "None"}');

    // Parse values
    final idKategori = _formData['id_kategori'] ?? '';
    final judul = _formData['judul'] ?? '';
    final deskripsi = _formData['deskripsi'] ?? '';
    final nominal = int.tryParse(
          _formData['nominal']?.toString().replaceAll(
                    RegExp(r'[^0-9]'),
                    '',
                  ) ??
              '0',
        ) ??
        0;
    final assetJaminan = _formData['asset_jaminan'] ?? '';
    final nilaiJaminan = int.tryParse(
          _formData['nilai_jaminan']?.toString().replaceAll(
                    RegExp(r'[^0-9]'),
                    '',
                  ) ??
              '0',
        ) ??
        0;
    final lokasiUsaha = _formData['lokasi_usaha'] ?? '';
    final detailLokasi = _formData['detail_lokasi'] ?? '';
    final pendapatanPerbulan = int.tryParse(
          _formData['pendapatan_perbulan']?.toString().replaceAll(
                    RegExp(r'[^0-9]'),
                    '',
                  ) ??
              '0',
        ) ??
        0;
    final pengeluaranPerbulan = int.tryParse(
          _formData['pengeluaran_perbulan']?.toString().replaceAll(
                    RegExp(r'[^0-9]'),
                    '',
                  ) ??
              '0',
        ) ??
        0;
    final limitSiklus =
        int.tryParse(_formData['limit_siklus']?.toString() ?? '0') ?? 0;
    final bagianPelaksana =
        int.tryParse(_formData['bagian_pelaksana']?.toString() ?? '0') ?? 0;
    final bagianKoperasi =
        int.tryParse(_formData['bagian_koperasi']?.toString() ?? '0') ?? 0;
    final bagianPemilik =
        int.tryParse(_formData['bagian_pemilik']?.toString() ?? '0') ?? 0;
    final bagianPendana =
        int.tryParse(_formData['bagian_pendana']?.toString() ?? '0') ?? 0;

    // Validation
    final validationErrors = <String>[];
    if (idKategori.isEmpty) validationErrors.add('ID Kategori kosong');
    if (judul.isEmpty) validationErrors.add('Judul kosong');
    if (deskripsi.isEmpty) validationErrors.add('Deskripsi kosong');
    if (nominal <= 0) validationErrors.add('Nominal tidak valid: $nominal');
    if (assetJaminan.isEmpty) validationErrors.add('Asset Jaminan kosong');
    if (nilaiJaminan <= 0)
      validationErrors.add('Nilai Jaminan tidak valid: $nilaiJaminan');
    if (lokasiUsaha.isEmpty) validationErrors.add('Lokasi Usaha kosong');
    if (detailLokasi.isEmpty) validationErrors.add('Detail Lokasi kosong');
    if (pendapatanPerbulan <= 0)
      validationErrors.add('Pendapatan tidak valid: $pendapatanPerbulan');
    if (pengeluaranPerbulan <= 0)
      validationErrors.add('Pengeluaran tidak valid: $pengeluaranPerbulan');
    if (limitSiklus <= 0)
      validationErrors.add('Limit Siklus tidak valid: $limitSiklus');

    if (validationErrors.isNotEmpty) {
      throw Exception('Validation failed: ${validationErrors.join(", ")}');
    }

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
      // ✅ PERBAIKAN: Kirim path file baru atau existing path
      dokumenProyeksi:
          _dokumenProyeksiFile?.path ?? _formData['dokumen_proyeksi'],
    );

    // ✅ PERBAIKAN: Ambil existing dokumen yang masih di-keep
    final existingDokumen = _formData['dokumen'] as List<dynamic>?;
    final existingDokumenPaths = existingDokumen
        ?.map((e) => e.toString())
        .where((path) => path.isNotEmpty)
        .toList();

    print('📋 Existing dokumen to keep: $existingDokumenPaths');
    print('📎 New dokumen files: ${_dokumenFiles.length}');

    print('🚀 Calling updateProject service...');
    _response = await _projectService.updateProject(
      projectId: _editingProjectId!,
      project: request,
      dokumenFiles: _dokumenFiles.isNotEmpty ? _dokumenFiles : null,
      brosurProdukFile: _brosurProdukFile,
      dokumenProyeksiFile: _dokumenProyeksiFile,
      existingDokumen: existingDokumenPaths, // ✅ TAMBAHAN
    );

    _status = ProjectStatus.success;
    notifyListeners();

    print('✅ Update successful in provider');
    return true;
  } catch (e) {
    _status = ProjectStatus.error;
    _errorMessage = e.toString().replaceAll('Exception: ', '');
    notifyListeners();

    print('❌ Update failed in provider: $_errorMessage');
    return false;
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

  // Create project
  Future<bool> createProject() async {
    try {
      _status = ProjectStatus.loading;
      _errorMessage = null;
      notifyListeners();

      if (_dokumenProyeksiFile == null) {
        throw Exception('Dokumen proyeksi wajib diupload');
      }

      final idKategori = _formData['id_kategori'] ?? '';
      final judul = _formData['judul'] ?? '';
      final deskripsi = _formData['deskripsi'] ?? '';
      final nominalStr = _formData['nominal']?.toString() ?? '0';
      final nominal =
          int.tryParse(nominalStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final assetJaminan = _formData['asset_jaminan'] ?? '';
      final nilaiJaminanStr = _formData['nilai_jaminan']?.toString() ?? '0';
      final nilaiJaminan =
          int.tryParse(nilaiJaminanStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final lokasiUsaha = _formData['lokasi_usaha'] ?? '';
      final detailLokasi = _formData['detail_lokasi'] ?? '';
      final pendapatanStr = _formData['pendapatan_perbulan']?.toString() ?? '0';
      final pendapatanPerbulan =
          int.tryParse(pendapatanStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final pengeluaranStr =
          _formData['pengeluaran_perbulan']?.toString() ?? '0';
      final pengeluaranPerbulan =
          int.tryParse(pengeluaranStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final limitSiklusStr = _formData['limit_siklus']?.toString() ?? '0';
      final limitSiklus = int.tryParse(limitSiklusStr) ?? 0;

      final bagianPelaksanaStr =
          _formData['bagian_pelaksana']?.toString() ?? '0';
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
      if (nilaiJaminan <= 0)
        validationErrors.add('Nilai Jaminan tidak valid: $nilaiJaminan');
      if (lokasiUsaha.isEmpty) validationErrors.add('Lokasi Usaha kosong');
      if (detailLokasi.isEmpty) validationErrors.add('Detail Lokasi kosong');
      if (pendapatanPerbulan <= 0)
        validationErrors.add('Pendapatan tidak valid: $pendapatanPerbulan');
      if (pengeluaranPerbulan <= 0)
        validationErrors.add('Pengeluaran tidak valid: $pengeluaranPerbulan');
      if (limitSiklus <= 0)
        validationErrors.add('Limit Siklus tidak valid: $limitSiklus');

      if (validationErrors.isNotEmpty) {
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

      // Call service
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

  Future<bool> signAgreementLetter(String projectId, File signatureFile) async {
    try {
      _isSigningAgreement = true;
      _signAgreementError = null;
      notifyListeners();

      print('\n📝 === SIGNING AGREEMENT IN PROVIDER ===');
      print('Project ID: $projectId');
      print('Signature file: ${signatureFile.path}');

      final result = await _projectService.signAgreementLetter(
        projectId: projectId,
        signatureFile: signatureFile,
      );

      print('✅ Agreement signed successfully');
      print('Result: $result');

      // Refresh agreement data
      await loadAgreementLetter(projectId);

      // Refresh project detail
      await getProjectDetail(projectId);

      // Refresh history
      await loadProjectHistory(projectId);

      _isSigningAgreement = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isSigningAgreement = false;
      _signAgreementError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();

      print('❌ Sign agreement failed in provider: $_signAgreementError');
      return false;
    }
  }

  /// Clear sign agreement error
  void clearSignAgreementError() {
    _signAgreementError = null;
    notifyListeners();
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

  // Load all projects (public list)
  Future<void> loadAllProjects({String? status, String? search}) async {
    try {
      _isLoadingAllProjects = true;
      _allProjectsError = null;
      notifyListeners();

      _allProjects = await _projectService.getAllProjects(
        status: status,
        search: search,
      );

      _isLoadingAllProjects = false;
      notifyListeners();
    } catch (e) {
      _isLoadingAllProjects = false;
      _allProjectsError = e.toString().replaceAll('Exception: ', '');
      _allProjects = [];
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
  List<ProjectListItem> getProjectsByStatus(
    String status, {
    bool newest = true,
  }) {
    var filtered = _userProjects.where((p) => p.status == status).toList();

    if (newest) {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return filtered;
  }

  // Get projects by multiple statuses with sorting
  List<ProjectListItem> getProjectsByStatuses(
    List<String> statuses, {
    bool newest = true,
  }) {
    var filtered =
        _userProjects.where((p) => statuses.contains(p.status)).toList();

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
    _allProjects.clear();
    _isLoadingAllProjects = false;
    _allProjectsError = null;
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
    _editingProjectId = null;
    _isUpdateMode = false;
    notifyListeners();
  }

  // Validate percentage total (should be 100%)
  bool validatePercentages() {
    final pelaksana =
        int.tryParse(_formData['bagian_pelaksana']?.toString() ?? '0') ?? 0;
    final koperasi =
        int.tryParse(_formData['bagian_koperasi']?.toString() ?? '0') ?? 0;
    final pemilik =
        int.tryParse(_formData['bagian_pemilik']?.toString() ?? '0') ?? 0;
    final pendana =
        int.tryParse(_formData['bagian_pendana']?.toString() ?? '0') ?? 0;

    final total = pelaksana + koperasi + pemilik + pendana;
    final isValid = total == 100;

    return isValid;
  }

  String getPercentageTotal() {
    final pelaksana =
        int.tryParse(_formData['bagian_pelaksana']?.toString() ?? '0') ?? 0;
    final koperasi =
        int.tryParse(_formData['bagian_koperasi']?.toString() ?? '0') ?? 0;
    final pemilik =
        int.tryParse(_formData['bagian_pemilik']?.toString() ?? '0') ?? 0;
    final pendana =
        int.tryParse(_formData['bagian_pendana']?.toString() ?? '0') ?? 0;

    return (pelaksana + koperasi + pemilik + pendana).toString();
  }

  // Reset status
  void resetStatus() {
    _status = ProjectStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear edit mode
  void clearEditMode() {
    _editingProjectId = null;
    _isUpdateMode = false;
    notifyListeners();
  }
}
