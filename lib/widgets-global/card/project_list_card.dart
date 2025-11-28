import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/screens/proyek/detail_project/project_detail.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';

class ProjectListCard extends StatefulWidget {
  final String projectId;
  final String imageUrl;
  final String status;
  final String title;
  final String owner;
  final int remainingDays;
  final int maxToken;

  const ProjectListCard({
    super.key,
    required this.projectId,
    required this.imageUrl,
    required this.status,
    required this.title,
    required this.owner,
    required this.remainingDays,
    required this.maxToken,
  });

  @override
  State<ProjectListCard> createState() => _ProjectListCardState();
}

class _ProjectListCardState extends State<ProjectListCard> {
  int _collectedToken = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTokenData();
  }

  Future<void> _loadTokenData() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      // Load investors untuk mendapatkan token terkumpul
      await context.read<ProjectProvider>().loadProjectInvestors(
        widget.projectId,
      );

      if (mounted) {
        final collected = context.read<ProjectProvider>().collectedToken;
        setState(() {
          _collectedToken = collected;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _collectedToken = 0;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;

    // Hitung progress (pastikan tidak lebih dari 1.0)
    final progress = widget.maxToken > 0
        ? (_collectedToken / widget.maxToken).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProjectDetailPage(
              projectId: widget.projectId,
              imageUrl: widget.imageUrl,
              status: widget.status,
              title: widget.title,
              owner: widget.owner,
              collectedToken: _collectedToken,
              remainingDays: widget.remainingDays,
              maxToken: widget.maxToken,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(deviceWidth * 0.012),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Color(0x0F4C577D).withOpacity(0.8),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  widget.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Konten
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * 0.02,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.status,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12 * textScale.clamp(1.0, 1.2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Judul
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Owner
                  Text(
                    widget.owner,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Progress
                  Stack(
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade200,
                        color: const Color(0xFF12B76A),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // Loading indicator overlay
                      if (_isLoading)
                        Positioned.fill(
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.grey.shade200,
                            color: const Color(0xFFF38E09),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Token dan sisa hari
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Terkumpul",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "$_collectedToken Token",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Sisa Hari",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${widget.remainingDays}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
