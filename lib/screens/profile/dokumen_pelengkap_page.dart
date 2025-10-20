import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:koperasi_rsb/widgets-global/button/green-button.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/form/uploadFile-Form.dart';
import 'package:koperasi_rsb/services/user_services.dart';
import 'package:koperasi_rsb/config/api_config.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DokumenPelengkapPage extends StatefulWidget {
  const DokumenPelengkapPage({super.key});
  @override
  State<DokumenPelengkapPage> createState() => _DokumenPelengkapPageState();
}

class _DokumenPelengkapPageState extends State<DokumenPelengkapPage> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  File? _ktpFile;
  File? _fotoFile;
  bool _ktpPicked = false;
  bool _fotoPicked = false;
  bool _isLoading = false;
  bool _isFetching = true;
  String? _userId;
  String? _existingKtp;
  String? _existingFoto;

  late double _deviceWidth;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  String _getFullUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    return '${ApiConfig.baseUrl}$path';
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
              if (mounted) {
                setState(() {
                  _existingKtp = _getFullUrl(userData['foto_ktp']);
                  _existingFoto = _getFullUrl(userData['foto_diri']);
                  _ktpPicked = _existingKtp != null && _existingKtp!.isNotEmpty;
                  _fotoPicked =
                      _existingFoto != null && _existingFoto!.isNotEmpty;
                  _ktpFile = null;
                  _fotoFile = null;
                });
              }
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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

  Future<void> _openFile(String? fileUrl) async {
    if (fileUrl == null || fileUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File tidak tersedia')),
      );
      return;
    }

    try {
      final Uri url = Uri.parse(fileUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak dapat membuka file';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showImagePreview(String? imageUrl, String title) {
    if (imageUrl == null || imageUrl.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(title),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Flexible(
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          SizedBox(height: 8),
                          Text('Gagal memuat gambar'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview(String? fileUrl, String label, File? localFile) {
    final hasNewFile = localFile != null;
    final hasExistingFile = fileUrl != null && fileUrl.isNotEmpty;

    if (!hasNewFile && !hasExistingFile) {
      return const SizedBox.shrink();
    }

    if (hasNewFile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview $label (Baru):',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              localFile,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.description, size: 48),
                        SizedBox(height: 8),
                        Text('File PDF/Dokumen'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    final isPdf = fileUrl!.toLowerCase().endsWith('.pdf');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label Tersimpan:',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            TextButton.icon(
              onPressed: () {
                if (isPdf) {
                  _openFile(fileUrl);
                } else {
                  _showImagePreview(fileUrl, label);
                }
              },
              icon: Icon(isPdf ? Icons.open_in_new : Icons.zoom_in, size: 18),
              label: Text(isPdf ? 'Buka PDF' : 'Lihat'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            if (isPdf) {
              _openFile(fileUrl);
            } else {
              _showImagePreview(fileUrl, label);
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isPdf
                ? Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.picture_as_pdf,
                              size: 48, color: Colors.red),
                          SizedBox(height: 8),
                          Text('File PDF'),
                          SizedBox(height: 4),
                          Text('Tap untuk membuka',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  )
                : Image.network(
                    fileUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red, size: 32),
                              SizedBox(height: 8),
                              Text('Gagal memuat gambar'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveData() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID tidak ditemukan')),
      );
      return;
    }

    if (_ktpFile == null && _fotoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih file yang ingin diupdate'),
          backgroundColor: Colors.orange,
        ),
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

      final result = await _userService.updateDokumen(
        userId: _userId!,
        token: token,
        fotoDiri: _fotoFile,
        fotoKtp: _ktpFile,
      );

      if (!mounted) return;

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Dokumen berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadUserData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal menyimpan dokumen'),
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
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        backgroundColor: lightGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: darkGreen, size: 40),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Dokumen Pelengkap',
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
                                const Icon(
                                  Icons.description_rounded,
                                  size: 70,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Isi Dokumen Pelengkap",
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
                                FileUploadForm(
                                  label: 'Foto KTP',
                                  isRequired: true,
                                  descriptions: const [
                                    '• Upload foto KTP jelas dan asli',
                                    '• Maksimum ukuran 10 MB',
                                    '• Format: JPG, JPEG, PNG, PDF'
                                  ],
                                  existingFileUrl: _existingKtp,
                                  onFilePicked: (file) {
                                    if (!mounted) return;
                                    setState(() {
                                      _ktpFile = file;
                                      _ktpPicked = file != null ||
                                          (_existingKtp != null &&
                                              _existingKtp!.isNotEmpty);
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),
                                _buildFilePreview(
                                    _existingKtp, 'Foto KTP', _ktpFile),
                                const SizedBox(height: 24),
                                const Divider(),
                                const SizedBox(height: 24),
                                FileUploadForm(
                                  label: 'Foto Diri',
                                  isRequired: true,
                                  descriptions: const [
                                    '• Upload foto wajah jelas',
                                    '• Maksimum ukuran 10 MB'
                                  ],
                                  existingFileUrl: _existingFoto,
                                  onFilePicked: (file) {
                                    if (!mounted) return;
                                    setState(() {
                                      _fotoFile = file;
                                      _fotoPicked = file != null ||
                                          (_existingFoto != null &&
                                              _existingFoto!.isNotEmpty);
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),
                                _buildFilePreview(
                                    _existingFoto, 'Foto Diri', _fotoFile),
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
