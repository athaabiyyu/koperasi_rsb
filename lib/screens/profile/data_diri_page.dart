import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:koperasi_rsb/services/user_services.dart';
import 'package:koperasi_rsb/providers/user_provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class DataDiriPage extends StatefulWidget {
  const DataDiriPage({super.key});
  @override
  State<DataDiriPage> createState() => _DataDiriPageState();
}

class _DataDiriPageState extends State<DataDiriPage> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();
  final _nik = TextEditingController();
  final _nama = TextEditingController();
  final _hp = TextEditingController();
  final _tempat = TextEditingController();
  final _tanggal = TextEditingController();

  bool _isLoading = false;
  bool _isFetching = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
              final noHp = userData['no_hp'] ?? '';
              if (mounted) {
                setState(() {
                  _nik.text = userData['nik'] ?? '';
                  _nama.text = userData['nama'] ?? '';
                  _hp.text = noHp.startsWith('62') ? noHp.substring(2) : noHp;
                  _tempat.text = userData['tempat_lahir'] ?? '';
                  _tanggal.text = userData['tanggal_lahir'] ?? '';
                });
              }
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    } finally {
      if (mounted) setState(() => _isFetching = false);
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

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2003, 3, 3),
      firstDate: DateTime(1950),
      lastDate: now,
      helpText: 'Pilih Tanggal Lahir',
    );
    if (picked != null) {
      if (!mounted) return;
      _tanggal.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() {});
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
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = authProvider.token;
      final formattedHp = '62${_hp.text}';

      if (token == null) throw Exception('Token tidak ditemukan');

      final result = await _userService.updateDataDiri(
        userId: _userId!,
        token: token,
        nik: _nik.text,
        nama: _nama.text,
        noHp: formattedHp,
        tempatLahir: _tempat.text,
        tanggalLahir: _tanggal.text,
      );

      if (!mounted) return;

      if (result['success']) {
        await userProvider.refreshUserProfile(
          userId: _userId!,
          token: token,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Data Diri berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal menyimpan data'),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nik.dispose();
    _nama.dispose();
    _hp.dispose();
    _tempat.dispose();
    _tanggal.dispose();
    super.dispose();
  }

  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        backgroundColor: lightGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded,
              color: darkGreen, size: 40),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Data Diri',
          style: GoogleFonts.poppins(
            fontSize: _deviceWidth * 0.05,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
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
                                // 🪪 Ganti dari foto ke ikon badge
                                const Icon(
                                  Icons.badge_rounded,
                                  size: 70,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Ubah Data Diri",
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
                                CustomTextFormField(
                                  label: 'NIK',
                                  hint: 'Nomor Induk Kependudukan',
                                  controller: _nik,
                                  keyboardType: TextInputType.number,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Wajib diisi';
                                    }
                                    if (v.length != 16) {
                                      return 'Harus 16 digit';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                CustomTextFormField(
                                  label: 'Nama Lengkap',
                                  hint: 'Nama sesuai KTP',
                                  controller: _nama,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                PhoneNumberField(
                                  controller: _hp,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Nomor wajib diisi';
                                    }
                                    if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
                                      return 'Hanya boleh angka';
                                    }
                                    if (v.length < 9 || v.length > 12) {
                                      return 'Nomor HP harus 9–12 digit';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFormField(
                                        label: 'Tempat Lahir',
                                        hint: 'Kota',
                                        controller: _tempat,
                                        validator: (v) {
                                          if (v == null || v.isEmpty) {
                                            return 'Wajib diisi';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: _pickDate,
                                        child: AbsorbPointer(
                                          child: CustomTextFormField(
                                            label: 'Tanggal Lahir',
                                            hint: 'DD/MM/YYYY',
                                            controller: _tanggal,
                                            validator: (v) {
                                              if (v == null || v.isEmpty) {
                                                return 'Wajib diisi';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
