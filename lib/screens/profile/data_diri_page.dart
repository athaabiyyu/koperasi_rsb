import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/widgets-global/form/textFormField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/services/user_services.dart';
import 'package:koperasi_rsb/utils/shared_preferences_helper.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'dart:convert';

class DataDiriPage extends StatefulWidget {
  const DataDiriPage({super.key});
  @override
  State<DataDiriPage> createState() => _DataDiriPageState();
}

class _DataDiriPageState extends State<DataDiriPage> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();
  final _nik = TextEditingController(text: '3501234567890124');
  final _nama = TextEditingController(text: 'budiono siregar');
  final _hp = TextEditingController(text: '6281234567891');
  final _tempat = TextEditingController(text: 'Surabaya');
  final _tanggal = TextEditingController(text: '03/03/2003');
  
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
        // Decode JWT untuk mendapatkan user ID
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
              if (mounted) {
                setState(() {
                  _nik.text = userData['nik'] ?? '';
                  _nama.text = userData['nama'] ?? '';
                  _hp.text = userData['no_hp'] ?? '';
                  _tempat.text = userData['tempat_lahir'] ?? '';
                  _tanggal.text = userData['tanggal_lahir'] ?? '';
                });
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

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2003, 3, 3),
        firstDate: DateTime(1950),
        lastDate: now,
        helpText: 'Pilih Tanggal Lahir');
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
      final token = authProvider.token;

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final result = await _userService.updateDataDiri(
        userId: _userId!,
        token: token,
        nik: _nik.text,
        nama: _nama.text,
        noHp: _hp.text,
        tempatLahir: _tempat.text,
        tanggalLahir: _tanggal.text,
      );

      if (!mounted) return;

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Data Diri berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        title: const Text('Data Diri'),
        backgroundColor: lightGreen,
        elevation: 0,
      ),
      body: _isFetching
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card(
                        child: Column(
                      children: [
                        CustomTextFormField(
                          label: 'NIK',
                          hint: 'Nomor Induk Kependudukan',
                          controller: _nik,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Wajib diisi';
                            if (v.length != 16) return 'Harus 16 digit';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        CustomTextFormField(
                          label: 'Nama Lengkap',
                          hint: 'Nama sesuai KTP',
                          controller: _nama,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Wajib diisi';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        CustomTextFormField(
                          label: 'No. Handphone',
                          hint: '08xxxxxxxx',
                          controller: _hp,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Wajib diisi';
                            if (v.length < 10) return 'Minimal 10 digit';
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
                                  if (v == null || v.isEmpty)
                                    return 'Wajib diisi';
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
                                      if (v == null || v.isEmpty)
                                        return 'Wajib diisi';
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: _isLoading ? null : _saveData,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text('SIMPAN',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: strokeGray),
        ),
        child: child,
      );
}