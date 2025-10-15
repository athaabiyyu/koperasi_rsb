import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/dropdownFormField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/services/user_services.dart';
import 'package:koperasi_rsb/services/wilayah_service.dart';
import 'package:koperasi_rsb/models/wilayah_model.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'dart:convert';

class AlamatPage extends StatefulWidget {
  const AlamatPage({super.key});
  @override
  State<AlamatPage> createState() => _AlamatPageState();
}

class _AlamatPageState extends State<AlamatPage> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();
  final _wilayahService = WilayahService();
  final _detail = TextEditingController();

  late double _deviceWidth;

  // Province, Regency, District data
  List<Province> _provinces = [];
  List<Regency> _regencies = [];
  List<District> _districts = [];

  // Selected values
  Province? _selectedProvince;
  Regency? _selectedRegency;
  District? _selectedDistrict;

  // Saved codes from database
  String? _savedProvinceCode;
  String? _savedRegencyCode;
  String? _savedDistrictCode;

  bool _isLoading = false;
  bool _isFetching = true;
  bool _isLoadingRegencies = false;
  bool _isLoadingDistricts = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Load provinces first
    await _loadProvinces();
    // Then load user data
    await _loadUserData();
  }

  Future<void> _loadProvinces() async {
    try {
      final provinces = await _wilayahService.getProvinces();
      if (mounted) {
        setState(() {
          _provinces = provinces;
        });
        print('Provinces loaded: ${_provinces.length}');
      }
    } catch (e) {
      print('Error loading provinces: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data provinsi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadRegencies(String provinceCode) async {
    setState(() {
      _isLoadingRegencies = true;
      _regencies = [];
      _districts = [];
      _selectedRegency = null;
      _selectedDistrict = null;
    });

    try {
      final regencies = await _wilayahService.getRegencies(provinceCode);
      if (mounted) {
        setState(() {
          _regencies = regencies;
          _isLoadingRegencies = false;
        });
      }
    } catch (e) {
      print('Error loading regencies: $e');
      if (mounted) {
        setState(() => _isLoadingRegencies = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data kabupaten/kota: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadDistricts(String regencyCode) async {
    setState(() {
      _isLoadingDistricts = true;
      _districts = [];
      _selectedDistrict = null;
    });

    try {
      final districts = await _wilayahService.getDistricts(regencyCode);
      if (mounted) {
        setState(() {
          _districts = districts;
          _isLoadingDistricts = false;
        });
      }
    } catch (e) {
      print('Error loading districts: $e');
      if (mounted) {
        setState(() => _isLoadingDistricts = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data kecamatan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadUserData() async {
    setState(() => _isFetching = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      if (token != null) {
        final decodedToken = _decodeJwt(token);
        if (decodedToken != null) {
          _userId = decodedToken['id'] as String?;

          if (_userId != null) {
            final result = await _userService.getUserById(
              userId: _userId!,
              token: token,
            );

            if (result['success'] && result['data'] != null) {
              final userData = result['data'];

              // Set detail alamat
              _detail.text = userData['alamat'] ?? '';

              // Ambil code dari database
              _savedProvinceCode = userData['provinsi']?.toString().trim();
              _savedRegencyCode = userData['kota']?.toString().trim();
              _savedDistrictCode = userData['kecamatan']?.toString().trim();

              print('=== DEBUG LOAD DATA ===');
              print('Saved Province Code: $_savedProvinceCode');
              print('Saved Regency Code: $_savedRegencyCode');
              print('Saved District Code: $_savedDistrictCode');
              print('Available Provinces: ${_provinces.length}');

              // Cari dan set provinsi berdasarkan code
              if (_savedProvinceCode != null &&
                  _savedProvinceCode!.isNotEmpty &&
                  _provinces.isNotEmpty) {
                try {
                  final province = _provinces.firstWhere(
                    (p) => p.code.trim() == _savedProvinceCode,
                  );

                  print('Found Province: ${province.name} (${province.code})');
                  _selectedProvince = province;

                  // Load regencies untuk provinsi ini
                  await _loadRegencies(province.code);

                  print('Loaded Regencies: ${_regencies.length}');

                  // Set regency jika ada
                  if (_savedRegencyCode != null &&
                      _savedRegencyCode!.isNotEmpty &&
                      _regencies.isNotEmpty) {
                    try {
                      final regency = _regencies.firstWhere(
                        (r) => r.code.trim() == _savedRegencyCode,
                      );

                      print('Found Regency: ${regency.name} (${regency.code})');
                      _selectedRegency = regency;

                      // Load districts untuk regency ini
                      await _loadDistricts(regency.code);

                      print('Loaded Districts: ${_districts.length}');

                      // Set district jika ada
                      if (_savedDistrictCode != null &&
                          _savedDistrictCode!.isNotEmpty &&
                          _districts.isNotEmpty) {
                        try {
                          final district = _districts.firstWhere(
                            (d) => d.code.trim() == _savedDistrictCode,
                          );

                          print(
                              'Found District: ${district.name} (${district.code})');
                          _selectedDistrict = district;
                        } catch (e) {
                          print('District not found: $_savedDistrictCode');
                          print(
                              'Available districts: ${_districts.map((d) => d.code).toList()}');
                        }
                      }
                    } catch (e) {
                      print('Regency not found: $_savedRegencyCode');
                      print(
                          'Available regencies: ${_regencies.map((r) => r.code).toList()}');
                    }
                  }
                } catch (e) {
                  print('Province not found: $_savedProvinceCode');
                  print(
                      'Available provinces: ${_provinces.map((p) => p.code).toList()}');
                }
              }

              if (mounted) {
                setState(() {});
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      if (mounted) {
        setState(() => _isFetching = false);
      }
    }
  }

  Map<String, dynamic>? _decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      String payload = parts[1];
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');

      switch (payload.length % 4) {
        case 0:
          break;
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
        default:
          return null;
      }

      final decoded = utf8.decode(base64.decode(payload));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID tidak ditemukan')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      // Kirim CODE ke database, bukan nama
      final result = await _userService.updateAlamat(
        userId: _userId!,
        token: token,
        provinsi: _selectedProvince?.code ?? '',
        kota: _selectedRegency?.code ?? '',
        kecamatan: _selectedDistrict?.code ?? '',
        alamat: _detail.text,
      );

      if (!mounted) return;

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Alamat berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal menyimpan alamat'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _detail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        title: Text(
          'Alamat',
          style: GoogleFonts.poppins(
            fontSize: _deviceWidth * 0.05,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: lightGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isFetching
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Bagian dark green (menyatu dengan card)
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: darkGreen,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 70,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Ubah Alamat",
                                  style: GoogleFonts.poppins(
                                    fontSize: _deviceWidth * 0.05,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                  height: 30,
                                  indent: _deviceWidth * 0.25,
                                  endIndent: _deviceWidth * 0.25,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 2),

                          // 🔹 Form bagian putih
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              children: [
                                CustomDropdownFormField(
                                  label: 'Provinsi',
                                  hint: 'Pilih Provinsi',
                                  value: _selectedProvince?.name,
                                  items: _provinces.map((p) => p.name).toList(),
                                  onChanged: (value) {
                                    final province = _provinces.firstWhere(
                                      (p) => p.name == value,
                                    );
                                    setState(() {
                                      _selectedProvince = province;
                                    });
                                    _loadRegencies(province.code);
                                  },
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return 'Pilih provinsi';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                CustomDropdownFormField(
                                  label: 'Kota / Kabupaten',
                                  hint: _isLoadingRegencies
                                      ? 'Memuat...'
                                      : 'Pilih Kota/Kabupaten',
                                  value: _selectedRegency?.name,
                                  items: _regencies.map((r) => r.name).toList(),
                                  onChanged: _isLoadingRegencies
                                      ? null
                                      : (value) {
                                          final regency = _regencies.firstWhere(
                                            (r) => r.name == value,
                                          );
                                          setState(() {
                                            _selectedRegency = regency;
                                          });
                                          _loadDistricts(regency.code);
                                        },
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return 'Pilih kota';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                CustomDropdownFormField(
                                  label: 'Kecamatan',
                                  hint: _isLoadingDistricts
                                      ? 'Memuat...'
                                      : 'Pilih Kecamatan',
                                  value: _selectedDistrict?.name,
                                  items: _districts.map((d) => d.name).toList(),
                                  onChanged: _isLoadingDistricts
                                      ? null
                                      : (value) {
                                          final district =
                                              _districts.firstWhere(
                                            (d) => d.name == value,
                                          );
                                          setState(() {
                                            _selectedDistrict = district;
                                          });
                                        },
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return 'Pilih kecamatan';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                CustomTextFormField(
                                  label: 'Detail Alamat',
                                  hint: 'Nama jalan, RT/RW, patokan',
                                  controller: _detail,
                                  maxLines: 3,
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return 'Wajib diisi';
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 35),
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                    text:
                                        _isLoading ? 'Menyimpan...' : 'SIMPAN',
                                    onPressed: _isLoading ? () {} : _saveData,
                                    color: darkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: strokeGray),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: child,
      );
}
