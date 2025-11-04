import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/card/project_information.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';
import 'package:koperasi_rsb/models/project_list_model.dart';
import 'package:koperasi_rsb/utils/url_helper.dart';

class ProjectInformationTab extends StatelessWidget {
  final ProjectListItem project;

  const ProjectInformationTab({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.all(deviceWidth * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Project Info
          ProjectHeaderInfo(
            imageUrl: project.mainImageUrl,
            status: project.statusDisplay,
            title: project.judul,
            owner: project.user.name,
            maxToken: project.tokenDitawarkan,
            nominalDisetujui: project.nominalDisetujui ?? project.nominal,
            hargaPerUnit: project.hargaPerUnit ?? 0,
            minimalPembelian: project.minBeli,
            maksimalPembelian: project.maxBeli,
            selesaiPenggalanganDana: project.selesaiPenggalanganDana,
          ),
          const SizedBox(height: 20),

          // Deskripsi Proyek
          const Text(
            "Deskripsi Proyek",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          SizedBox(height: deviceHeight * 0.012),
          Text(
            project.deskripsi,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: deviceHeight * 0.025),

          // Detail Proyek Section
          const Text(
            "Informasi Pendanaan",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          SizedBox(height: deviceHeight * 0.012),
          _buildDetailProjectCard(project, deviceWidth, deviceHeight),
          SizedBox(height: deviceHeight * 0.025),

          // Pembagian Keuntungan
          const Text(
            "Pembagian Keuntungan",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          SizedBox(height: deviceHeight * 0.012),
          
          if (project.hasProfitSharing) ...[
            _buildProfitSharingCard(project, deviceWidth, deviceHeight),
            SizedBox(height: deviceHeight * 0.012),
          ] else
            const Text(
              "Pembagian keuntungan belum ditentukan.",
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.grey),
            ),
          
          SizedBox(height: deviceHeight * 0.012),

          Row(
            children: [
              const Text(
                "Laporan Laba Rugi Diupdate Setiap: ",
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(width: 4),
              Text(
                "${project.limitSiklus ?? 6} Bulan",
                style: const TextStyle(
                  color: darkGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: deviceHeight * 0.025),

          // Lampiran Proyek
          const Text(
            "Lampiran Proyek",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          SizedBox(height: deviceHeight * 0.012),

          // Brosur Produk
          if (project.brosurProduk != null && project.brosurProduk!.isNotEmpty)
            AttachmentTile(
              data: {
                'name': 'Brosur Produk',
                'size': '',
                'url': UrlHelper.getFullImageUrl(project.brosurProduk!),
              },
              deviceWidth: deviceWidth,
              onTap: () => showAttachmentPreview(context, {
                'name': 'Brosur Produk',
                'url': UrlHelper.getFullImageUrl(project.brosurProduk!),
              }),
            ),

          // Dokumen Proyeksi
          AttachmentTile(
            data: {
              'name': 'Dokumen Proyeksi',
              'size': '',
              'url': UrlHelper.getFullImageUrl(project.dokumenProyeksi),
            },
            deviceWidth: deviceWidth,
            onTap: () => showAttachmentPreview(context, {
              'name': 'Dokumen Proyeksi',
              'url': UrlHelper.getFullImageUrl(project.dokumenProyeksi),
            }),
          ),

          // Dokumen Tambahan
          ...project.dokumenTambahan.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final doc = entry.value;
              final documentName = 'Dokumen Pendukung -${index + 1}';
              
              return AttachmentTile(
                data: {
                  'name': documentName,
                  'size': '',
                  'url': UrlHelper.getFullImageUrl(doc.url),
                },
                deviceWidth: deviceWidth,
                onTap: () => showAttachmentPreview(context, {
                  'name': documentName,
                  'url': UrlHelper.getFullImageUrl(doc.url),
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  // Detail Project Card
  Widget _buildDetailProjectCard(ProjectListItem project, double deviceWidth, double deviceHeight) {
    return Container(
      padding: EdgeInsets.all(deviceWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
           
          _buildDetailRow(
            "Aset Jaminan",
            project.assetJaminan,
            deviceWidth,
          ),
          _buildDivider(),
          _buildDetailRow(
            "Nominal Jaminan",
            "Rp ${_formatCurrency(project.nilaiJaminan)}",
            deviceWidth,
          ),
          _buildDivider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Model dan Rencana Bisnis",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101828),
              ),
            ),
          ),
          _buildDivider(),
          _buildDetailRow(
            "Pendapatan/${project.limitSiklus ?? 6} bulan",
            "Rp ${_formatCurrency(project.pendapatanPerbulan)}",
            deviceWidth,
          ),
          _buildDivider(),
          _buildDetailRow(
            "Pengeluaran/${project.limitSiklus ?? 6} bulan",
            "Rp ${_formatCurrency(project.pengeluaranPerbulan)}",
            deviceWidth,
          ),
          if (project.user.phone != null && project.user.phone!.isNotEmpty) ...[
            _buildDivider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Kontak Pemilik Proyek",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF101828),
                ),
              ),
            ),
            _buildDivider(),
            _buildDetailRow(
              "No. Whatsapp",
              project.user.phone!,
              deviceWidth,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double deviceWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF101828),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFFF3F4F6),
    );
  }

  String _formatCurrency(int amount) {
    final amountStr = amount.toString();
    final buffer = StringBuffer();
    var count = 0;
    
    for (var i = amountStr.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(amountStr[i]);
      count++;
    }
    
    return buffer.toString().split('').reversed.join('');
  }

  Widget _buildProfitSharingCard(ProjectListItem project, double deviceWidth, double deviceHeight) {
    final total = project.totalProfitSharing;
    final isValid = total == 100;
    
    return Container(
      padding: EdgeInsets.all(deviceWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          
          _buildProfitBarRow("Pelaksana", project.bagianPelaksana ?? 0, const Color(0xFF9DA4B4), deviceWidth),
          const SizedBox(height: 12),
          _buildProfitBarRow("Koperasi", project.bagianKoperasi ?? 0, const Color(0xFF12B76A), deviceWidth),
          const SizedBox(height: 12),
          _buildProfitBarRow("Pemilik", project.bagianPemilik ?? 0, const Color(0xFFF38E09), deviceWidth),
          const SizedBox(height: 12),
          _buildProfitBarRow("Pendana", project.bagianPendana ?? 0, const Color(0xFF667085), deviceWidth),
        ]
      ),
    );
  }

  Widget _buildProfitBarRow(String label, int percentage, Color color, double deviceWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Text(
              "$percentage%",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (percentage / 100).clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Attachment Tile Widget
class AttachmentTile extends StatelessWidget {
  final Map<String, String> data;
  final double deviceWidth;
  final VoidCallback onTap;
  final bool showDivider;
  
  const AttachmentTile({
    super.key,
    required this.data,
    required this.deviceWidth,
    required this.onTap,
    this.showDivider = false,
  });

  bool get _isImage {
    final url = data['url'] ?? '';
    return UrlHelper.isImageByExtension(url);
  }

  IconData get _fileIcon {
    final url = (data['url'] ?? '').toLowerCase();
    if (_isImage) return Icons.image;
    if (url.endsWith('.pdf')) return Icons.picture_as_pdf;
    if (url.endsWith('.doc') || url.endsWith('.docx')) return Icons.description;
    if (url.endsWith('.xls') || url.endsWith('.xlsx')) return Icons.table_chart;
    return Icons.insert_drive_file;
  }

  Color get _iconColor {
    final url = (data['url'] ?? '').toLowerCase();
    if (_isImage) return const Color(0xFF12B76A);
    if (url.endsWith('.pdf')) return const Color(0xFFEF4444);
    if (url.endsWith('.doc') || url.endsWith('.docx')) return const Color(0xFF3B82F6);
    if (url.endsWith('.xls') || url.endsWith('.xlsx')) return const Color(0xFF10B981);
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.04,
                vertical: deviceWidth * 0.03,
              ),
              child: Row(
                children: [
                  // Icon with background
                  Container(
                    width: deviceWidth * 0.12,
                    height: deviceWidth * 0.12,
                    decoration: BoxDecoration(
                      color: _iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _fileIcon,
                      color: _iconColor,
                      size: deviceWidth * 0.06,
                    ),
                  ),
                  SizedBox(width: deviceWidth * 0.03),
                  
                  // File info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? '-',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF101828),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (data['size']?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 2),
                          Text(
                            data['size']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Arrow icon
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Divider
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(left: deviceWidth * 0.04),
            child: Divider(
              height: 1,
              thickness: 1,
              color: const Color(0xFFF3F4F6),
            ),
          ),
      ],
    );
  }
}

// Attachment Preview Function
void showAttachmentPreview(BuildContext context, Map<String, String> file) {
  final name = file['name'] ?? '';
  final url = file['url'] ?? '';
  final isImage = UrlHelper.isImageByExtension(url);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 16),
              child: Row(
                children: [
                  // Icon berdasarkan tipe file
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isImage 
                          ? const Color(0xFF3B82F6).withOpacity(0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isImage ? Icons.image : Icons.insert_drive_file,
                      color: isImage ? const Color(0xFF3B82F6) : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: darkGreen,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isImage ? 'Gambar' : 'Dokumen',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1, thickness: 1),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: isImage && url.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          url,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 300,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Memuat gambar...',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 56,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Gagal memuat gambar',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32),
                                    child: Text(
                                      'Pastikan koneksi internet stabil',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Icon(
                                Icons.insert_drive_file,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Preview tidak tersedia',
                              style: GoogleFonts.roboto(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tipe file ini tidak dapat ditampilkan.\nSilakan download untuk melihat isinya.',
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                color: Colors.grey[500],
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      );
    },
  );
}