import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/login-regis-section.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/form/dateFormField.dart';
import 'package:koperasi_rsb/widgets-global/form/dropDownFormField.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:koperasi_rsb/services/wilayah_service.dart';
import 'package:koperasi_rsb/models/wilayah_model.dart';
import 'package:provider/provider.dart';

class RegistrationPage2 extends StatefulWidget {
  const RegistrationPage2({super.key});

  @override
  State<RegistrationPage2> createState() => _RegistrationPage2State();
}

class _RegistrationPage2State extends State<RegistrationPage2> {
  late double _deviceWidth;
  late double _deviceHeight;
  final _formKey = GlobalKey<FormState>();
  final WilayahService _wilayahService = WilayahService();

  // Controllers
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _detailAlamatController = TextEditingController();

  // Data lists
  List<Province> _provinces = [];
  List<Regency> _regencies = [];
  List<District> _districts = [];

  // Selected values
  Province? _selectedProvinsi;
  Regency? _selectedKota;
  District? _selectedKecamatan;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  @override
  void dispose() {
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _detailAlamatController.dispose();
    super.dispose();
  }

  // Load provinces
  Future<void> _loadProvinces() async {
    setState(() {});

    try {
      final provinces = await _wilayahService.getProvinces();
      setState(() {
        _provinces = provinces;
      });
    } catch (e) {
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat provinsi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Load regencies when province is selected
  Future<void> _loadRegencies(String provinceCode) async {
    setState(() {
      _regencies = [];
      _districts = [];
      _selectedKota = null;
      _selectedKecamatan = null;
    });

    try {
      final regencies = await _wilayahService.getRegencies(provinceCode);
      setState(() {
        _regencies = regencies;
      });
    } catch (e) {
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat kota/kabupaten: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Load districts when regency is selected
  Future<void> _loadDistricts(String regencyCode) async {
    setState(() {
      _districts = [];
      _selectedKecamatan = null;
    });

    try {
      final districts = await _wilayahService.getDistricts(regencyCode);
      setState(() {
        _districts = districts;
      });
    } catch (e) {
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat kecamatan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Function untuk handle next
  void _handleNext() {
    if (!_formKey.currentState!.validate()) return;

    // Validasi dropdown
    if (_selectedProvinsi == null ||
        _selectedKota == null ||
        _selectedKecamatan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap lengkapi semua dropdown'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Format tanggal lahir ke format YYYY-MM-DD
    String formattedDate = _tanggalLahirController.text;
    if (formattedDate.contains('/')) {
      List<String> parts = formattedDate.split('/');
      if (parts.length == 3) {
        formattedDate = '${parts[2]}-${parts[1]}-${parts[0]}';
      }
    }

    // Simpan data ke provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.saveRegistrationStep({
      'tempat_lahir': _tempatLahirController.text.trim(),
      'tanggal_lahir': formattedDate,
      'provinsi': _selectedProvinsi!.code, // ✅ Ubah dari .name ke .code
      'kota': _selectedKota!.code, // ✅ Ubah dari .name ke .code
      'kecamatan': _selectedKecamatan!.code, // ✅ Ubah dari .name ke .code
      'detail_alamat': _detailAlamatController.text.trim(),
    });

    // Navigate ke page 3
    Navigator.pushNamed(context, '/registration3');
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: _deviceHeight * 0.27,
                child: cardLoginRegisWidget(
                  title: "Lengkapi Data!",
                  subtitle:
                      "Silahkan lengkapi formulir ini untuk verivikasi akun anda",
                  deviceWidth: _deviceWidth,
                ),
              ),

              // Form section
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.07),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context)
                        .size
                        .height,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),

                        Row(
                          children: [
                            // Tempat Lahir
                            Expanded(
                              flex: 5,
                              child: CustomTextFormField(
                                controller: _tempatLahirController,
                                label: "Tempat Lahir",
                                hint: "Tempat Lahir Anda",
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Tempat lahir wajib diisi";
                                  } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                      .hasMatch(value)) {
                                    return "Format tidak valid";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Tanggal Lahir
                            Expanded(
                              flex: 5,
                              child: CustomDateFormField(
                                controller: _tanggalLahirController,
                                label: "Tanggal Lahir",
                                hint: "Pilih tanggal lahir",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Tanggal lahir wajib diisi";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                        // Provinsi Dropdown
                        CustomDropdownFormField(
                          label: "Provinsi",
                          hint: "Pilih Provinsi",
                          items: _provinces.map((p) => p.name).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Harus dipilih";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            final selected =
                                _provinces.firstWhere((p) => p.name == value);
                            setState(() {
                              _selectedProvinsi = selected;
                            });
                            _loadRegencies(selected.code);
                          },
                        ),

                        const SizedBox(height: 30),
                        // Kota/Kabupaten Dropdown
                        CustomDropdownFormField(
                          label: "Kota/Kabupaten",
                          hint: _selectedProvinsi == null
                              ? "Pilih provinsi terlebih dahulu"
                              : "Pilih Kota/Kabupaten",
                          items: _regencies.map((r) => r.name).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Harus dipilih";
                            }
                            return null;
                          },
                          onChanged: _selectedProvinsi == null
                              ? null
                              : (value) {
                                  final selected = _regencies
                                      .firstWhere((r) => r.name == value);
                                  setState(() {
                                    _selectedKota = selected;
                                  });
                                  _loadDistricts(selected.code);
                                },
                        ),

                        const SizedBox(height: 30),
                        // Kecamatan Dropdown
                        CustomDropdownFormField(
                          label: "Kecamatan",
                          hint: _selectedKota == null
                              ? "Pilih kota terlebih dahulu"
                              : "Pilih Kecamatan",
                          items: _districts.map((d) => d.name).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Harus dipilih";
                            }
                            return null;
                          },
                          onChanged: _selectedKota == null
                              ? null
                              : (value) {
                                  final selected = _districts
                                      .firstWhere((d) => d.name == value);
                                  setState(() {
                                    _selectedKecamatan = selected;
                                  });
                                },
                        ),

                        const SizedBox(height: 30),

                        CustomTextFormField(
                          controller: _detailAlamatController,
                          label: "Detail Alamat",
                          hint: "Cth. Jl. Abdul Gani Atas No. 23",
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Detail alamat wajib diisi";
                            }
                            return null;
                          },
                          maxLines: 2,
                        ),

                        const SizedBox(height: 50),

                        SizedBox(
                          width: _deviceWidth * 0.75,
                          height: 55,
                          child: CustomButton(
                            text: "SELANJUTNYA",
                            onPressed: _handleNext,
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
