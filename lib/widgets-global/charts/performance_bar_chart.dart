import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerformancePoint {
  final DateTime date;
  final double value;
  PerformancePoint(this.date, this.value);
}

class PerformanceBarChart extends StatefulWidget {
  final List<PerformancePoint>? data;
  final String title;

  const PerformanceBarChart({
    super.key,
    this.data,
    this.title = 'Grafik Performa Penyertaan Modal Usaha',
  });

  @override
  State<PerformanceBarChart> createState() => _PerformanceBarChartState();
}

enum _Range { oneMonth, threeMonths, oneYear, all }

class _PerformanceBarChartState extends State<PerformanceBarChart> {
  _Range _range = _Range.all;

  late List<PerformancePoint> _baseData;

  @override
  void initState() {
    super.initState();
    _baseData = (widget.data ?? _mockData())
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<PerformancePoint> _mockData() {
    final now = DateTime.now();
    // 18 bulan data bulanan
    return List.generate(18, (i) {
      final d = DateTime(now.year, now.month - 17 + i, 1);
      final base = 35 + (i * 1.8);
      final bump = (i == 12) ? 8 : (i == 14 ? 5 : 0);
      return PerformancePoint(d, base + bump);
    });
  }

  List<PerformancePoint> _filtered() {
    final now = DateTime.now();
    DateTime start;
    switch (_range) {
      case _Range.oneMonth:
        start = DateTime(now.year, now.month - 1, 1);
        break;
      case _Range.threeMonths:
        start = DateTime(now.year, now.month - 3, 1);
        break;
      case _Range.oneYear:
        start = DateTime(now.year - 1, now.month, 1);
        break;
      case _Range.all:
        return _baseData;
    }
    return _baseData
        .where((p) => p.date.isAfter(start) || _isSameMonth(p.date, start))
        .toList();
  }

  bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Make chart smaller so it doesn't cover half the screen on phones
    final height = (size.height * 0.22).clamp(150.0, 220.0);
    final data = _filtered();

    // Responsif: bila banyak bar, izinkan scroll horizontal
    final needsScroll = data.length > 8;
    final contentWidth = needsScroll ? (data.length * 48.0) : size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.poppins(
                fontSize: (size.width * 0.042).clamp(13, 16).toDouble(),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: height,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: contentWidth,
                  child: BarChart(
                    BarChartData(
                      minY: 0,
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 5,
                        getDrawingHorizontalLine: (v) => FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 26,
                            interval: 5,
                            getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final i = value.toInt();
                              if (i < 0 || i >= data.length)
                                return const SizedBox.shrink();
                              final d = data[i].date;
                              final labels = [
                                'Jan',
                                'Feb',
                                'Mar',
                                'Apr',
                                'Mei',
                                'Jun',
                                'Jul',
                                'Agu',
                                'Sep',
                                'Okt',
                                'Nov',
                                'Des',
                              ];
                              final label =
                                  '${labels[d.month - 1]} ${d.year % 100}';
                              // Tampilkan lebih jarang jika banyak
                              final show = needsScroll || i % 2 == 0;
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: show
                                    ? Text(
                                        label,
                                        style: GoogleFonts.poppins(
                                          fontSize: 9,
                                          color: Colors.grey[700],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(data.length, (i) {
                        final v = data[i].value;
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: v,
                              width: 14,
                              borderRadius: BorderRadius.circular(4),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF34C759), Color(0xFF2EA44F)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY:
                                    (data
                                        .map((e) => e.value)
                                        .reduce((a, b) => a > b ? a : b) *
                                    1.1),
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ],
                        );
                      }),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _RangeChips(
              range: _range,
              onChanged: (r) {
                setState(() => _range = r);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeChips extends StatelessWidget {
  final _Range range;
  final ValueChanged<_Range> onChanged;
  const _RangeChips({required this.range, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chipStyle = (bool selected) => OutlinedButton.styleFrom(
      backgroundColor: selected ? const Color(0xFF2EA44F) : Colors.white,
      foregroundColor: selected ? Colors.white : Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      side: BorderSide(
        color: selected ? const Color(0xFF2EA44F) : Colors.grey.shade300,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      textStyle: GoogleFonts.poppins(
        fontSize: (size.width * 0.03).clamp(10, 13).toDouble(),
        fontWeight: FontWeight.w600,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(
              style: chipStyle(range == _Range.oneMonth),
              onPressed: () => onChanged(_Range.oneMonth),
              child: const Text('1 Bulan'),
            ),
            OutlinedButton(
              style: chipStyle(range == _Range.threeMonths),
              onPressed: () => onChanged(_Range.threeMonths),
              child: const Text('3 Bulan'),
            ),
            OutlinedButton(
              style: chipStyle(range == _Range.oneYear),
              onPressed: () => onChanged(_Range.oneYear),
              child: const Text('1 Tahun'),
            ),
          ],
        ),
        OutlinedButton(
          style: chipStyle(range == _Range.all),
          onPressed: () => onChanged(_Range.all),
          child: const Text('Semua'),
        ),
      ],
    );
  }
}
