import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimelineStepItem extends StatelessWidget {
  final int index;
  final bool isLast;
  final String title;
  final String overallStatus; // overall status for this step
  final List<Map<String, dynamic>> events;
  final bool showContractButton;
  final bool hasAgreement;
  final bool isLoadingAgreement;
  final VoidCallback? onDownloadContract;
  final VoidCallback? onSignContract;
  final bool showRetryButton;
  final VoidCallback? onRetrySubmit;

  const TimelineStepItem({
    super.key,
    required this.index,
    required this.isLast,
    required this.title,
    this.overallStatus = 'upcoming',
    required this.events,
    this.showContractButton = false,
    this.hasAgreement = false,
    this.isLoadingAgreement = false,
    this.onDownloadContract,
    this.onSignContract,
    this.showRetryButton = false,
    this.onRetrySubmit,
  });

  Color _getStatusColor(String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'error':
      case 'failed':
        return Colors.red;
      case 'current':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getBackgroundColor(String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return Colors.green.shade50;
      case 'error':
      case 'failed':
        return Colors.red.shade50;
      case 'current':
        return Colors.blue.shade50;
      case 'pending':
        return Colors.orange.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  IconData _getStatusIcon(String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return Icons.check;
      case 'error':
      case 'failed':
        return Icons.close;
      case 'current':
        return Icons.access_time;
      case 'pending':
        return Icons.schedule;
      default:
        return Icons.lock;
    }
  }

  String _getOverallStatus() {
    if (events.isEmpty) return 'upcoming';
    // Return the latest event's status
    return events.last['type'] ?? 'upcoming';
  }

  @override
  Widget build(BuildContext context) {
    final overallStatus = _getOverallStatus();
    final statusColor = _getStatusColor(overallStatus);

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status indicator
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    _getStatusIcon(overallStatus),
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 8),
                // Events
                ...events.map((event) => _buildEventCard(event)),
                
                // Contract button (only for Kontrak Perjanjian step or after)
                if (showContractButton) ...[
                  const SizedBox(height: 12),
                  if (isLoadingAgreement)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (hasAgreement)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onDownloadContract,
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Download Kontrak'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onSignContract,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Tanda Tangani Kontrak'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final type = event['type'] as String;
    final message = event['message'] as String;
    final date = event['date'] as String;
    final backgroundColor = _getBackgroundColor(type);
    final textColor = _getStatusColor(type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Dashed line widget (keep existing implementation)
class DashedLineVertical extends StatelessWidget {
  final Color color;
  final double thickness;

  const DashedLineVertical({
    super.key,
    required this.color,
    required this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedLinePainter(color: color, thickness: thickness),
      size: const Size(1, double.infinity),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;

  _DashedLinePainter({required this.color, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    const dashHeight = 5.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}