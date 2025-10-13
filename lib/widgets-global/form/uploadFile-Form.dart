import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadForm extends StatefulWidget {
  final String label;
  final List<String>? descriptions;
  final int maxFileSizeMB;
  final void Function(File?)? onFilePicked; // ⭐ UBAH dari PlatformFile? ke File?
  final bool isRequired;
  final String? existingFileUrl; // ⭐ TAMBAHKAN parameter ini

  const FileUploadForm({
    super.key,
    required this.label,
    this.descriptions,
    this.maxFileSizeMB = 10,
    this.onFilePicked,
    this.isRequired = false,
    this.existingFileUrl, // ⭐ TAMBAHKAN parameter ini
  });

  @override
  State<FileUploadForm> createState() => _FileUploadFormState();
}

class _FileUploadFormState extends State<FileUploadForm> {
  PlatformFile? _pickedFile;
  File? _file; // ⭐ TAMBAHKAN untuk menyimpan File object

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'], // ⭐ Batasi tipe file
      withData: false, // ⭐ Ubah ke false, kita gunakan path
      withReadStream: false,
    );

    if (result != null) {
      PlatformFile platformFile = result.files.first;
      
      // ⭐ Validasi ukuran file
      if (platformFile.size / (1024 * 1024) <= widget.maxFileSizeMB) {
        // ⭐ Convert PlatformFile ke File
        if (platformFile.path != null) {
          File file = File(platformFile.path!);
          
          setState(() {
            _pickedFile = platformFile;
            _file = file;
          });
          
          // ⭐ Callback dengan File object
          if (widget.onFilePicked != null) {
            widget.onFilePicked!(file);
          }
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal membaca file. Silakan coba lagi.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ukuran file maksimal ${widget.maxFileSizeMB} MB'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _removeFile() {
    setState(() {
      _pickedFile = null;
      _file = null;
    });
    if (widget.onFilePicked != null) {
      widget.onFilePicked!(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⭐ Cek apakah ada file yang sudah dipilih atau existing file
    final hasFile = _pickedFile != null || 
                    (widget.existingFileUrl != null && 
                     widget.existingFileUrl!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
            children: widget.isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : const [],
          ),
        ),
        const SizedBox(height: 6),
        
        // ⭐ File picker area
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 150,
            decoration: BoxDecoration(
              color: lightGreen,
              border: Border.all(
                color: hasFile ? Colors.green : darkGreen,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  _pickedFile != null 
                      ? Icons.check_circle
                      : Icons.insert_drive_file,
                  color: _pickedFile != null 
                      ? Colors.green 
                      : const Color(0xFF00C853),
                  size: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _pickedFile?.name ?? 
                        'Tarik file di sini atau klik untuk mengunggah.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: _pickedFile != null
                              ? Colors.grey[700]
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // ⭐ Tampilkan info existing file jika ada
                      if (_pickedFile == null && 
                          widget.existingFileUrl != null && 
                          widget.existingFileUrl!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'File sudah ada',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                      // ⭐ Tampilkan ukuran file jika ada
                      if (_pickedFile != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${(_pickedFile!.size / 1024).toStringAsFixed(2)} KB',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // ⭐ Tombol hapus jika file sudah dipilih
                if (_pickedFile != null)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: _removeFile,
                    tooltip: 'Hapus file',
                  ),
              ],
            ),
          ),
        ),
        
        // ⭐ Descriptions
        if (widget.descriptions != null) ...[
          const SizedBox(height: 12),
          ...widget.descriptions!.map(
            (desc) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                desc,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}