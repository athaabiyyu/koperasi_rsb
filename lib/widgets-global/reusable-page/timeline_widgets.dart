import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_rsb/widgets-global/colors.dart';

class TimelineStepItem extends StatelessWidget {
  final int index;
  final bool isLast;
  final String title;
  final List<Map<String, dynamic>> events;

  const TimelineStepItem({
    super.key,
    required this.index,
    required this.isLast,
    required this.title,
    required this.events,
  });

  bool get isDone => events.isNotEmpty;
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    const lineColor = lightGreen;
    const successColor = Color(0xFF12B76A);
    const neutralColor = Color(0xFF98A2B3);
    const dangerColor = Colors.red;

    return Padding(
      padding: EdgeInsets.only(bottom: deviceHeight * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Center(
              child: isDone
                  ? Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: successColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  : Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        border: Border.all(color: lineColor),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${index + 1}",
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: neutralColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(width: deviceWidth * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: successColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "22 Januari, 2022 4:23 PM by",
                  style: GoogleFonts.roboto(fontSize: 12, color: neutralColor),
                ),
                const SizedBox(height: 10),
                ...events.map((event) {
                  final type = event['type'] as String? ?? 'info';
                  Color borderColor;
                  Color? bgColor;
                  Color textColor;
                  switch (type) {
                    case 'success':
                      borderColor = successColor;
                      bgColor = const Color(0xFFECF9F3);
                      textColor = successColor;
                      break;
                    case 'error':
                      borderColor = dangerColor;
                      bgColor = const Color(0xFFFFF1F1);
                      textColor = dangerColor;
                      break;
                    default:
                      borderColor = const Color(0xFFD0D5DD);
                      bgColor = Colors.white;
                      textColor = Colors.black;
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: bgColor,
                      shape: DashedBorderShape(
                        color: borderColor,
                        strokeWidth: 1.2,
                        dashLength: 6,
                        gapLength: 4,
                        borderRadius: 8,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['message'] ?? '',
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (event['date'] != null)
                          Text(
                            event['date'],
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: neutralColor,
                            ),
                          ),
                        if (event['actionLabel'] != null) ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: successColor),
                                foregroundColor: successColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(event['actionLabel']),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashedLineVertical extends StatelessWidget {
  final double thickness;
  final Color color;
  const DashedLineVertical({
    super.key,
    this.thickness = 1,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double dashLength = 4;
        const double gapLength = 4;
        final height = constraints.maxHeight;
        final dashCount = (height / (dashLength + gapLength)).floor();
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (index) {
            return SizedBox(
              height: dashLength,
              child: Center(
                child: Container(width: thickness, color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

class DashedBorderShape extends OutlinedBorder {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double borderRadius;

  const DashedBorderShape({
    required this.color,
    this.strokeWidth = 1,
    this.dashLength = 6,
    this.gapLength = 4,
    this.borderRadius = 8,
  });

  @override
  OutlinedBorder copyWith({
    BorderSide? side,
    BorderRadiusGeometry? borderRadius,
  }) {
    return DashedBorderShape(
      color: color,
      strokeWidth: strokeWidth,
      dashLength: dashLength,
      gapLength: gapLength,
      borderRadius: this.borderRadius,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;
    final dashedPath = _createDashedPath(path, dashLength, gapLength);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, double dashLength, double gapLength) {
    final Path dashedPath = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double next = distance + dashLength;
        dashedPath.addPath(
          metric.extractPath(distance, next.clamp(0.0, metric.length)),
          Offset.zero,
        );
        distance = next + gapLength;
      }
    }
    return dashedPath;
  }

  @override
  ShapeBorder scale(double t) => this;
}
