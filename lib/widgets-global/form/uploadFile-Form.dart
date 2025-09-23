import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadForm extends StatefulWidget {
  final String label;
  final List<String>? descriptions;
  final int maxFileSizeMB;
  final void Function(PlatformFile?)? onFilePicked;

  const FileUploadForm({
    super.key,
    required this.label,
    this.descriptions,
    this.maxFileSizeMB = 10,
    this.onFilePicked,
  });

  @override
  State<FileUploadForm> createState() => _FileUploadFormState();
}

class _FileUploadFormState extends State<FileUploadForm> {
  PlatformFile? _pickedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.size / (1024 * 1024) <= widget.maxFileSizeMB) {
        setState(() {
          _pickedFile = file;
        });
        if (widget.onFilePicked != null) widget.onFilePicked!(file);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ukuran file maksimal ${widget.maxFileSizeMB} MB')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 150,
            decoration: BoxDecoration(
              color: lightGreen,
              border: Border.all(color: darkGreen, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file, color: Color(0xFF00C853), size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _pickedFile?.name ?? 'Tarik file di sini atau klik untuk mengunggah.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: _pickedFile != null ? Colors.grey[600] : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.descriptions != null) ...[
          const SizedBox(height: 12),
          ...widget.descriptions!.map(
            (desc) => Text(
              desc,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ],
    );
  }
}
