// Model untuk Chart Token
class ChartTokenData {
  final int month;
  final int year;
  final double sumNominal;

  ChartTokenData({
    required this.month,
    required this.year,
    required this.sumNominal,
  });

  factory ChartTokenData.fromJson(Map<String, dynamic> json) {
    return ChartTokenData(
      month: json['month'] as int,
      year: json['year'] as int,
      sumNominal: (json['sum_nominal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
      'sum_nominal': sumNominal,
    };
  }

  // Convert ke PerformancePoint untuk chart
  DateTime get date => DateTime(year, month, 1);
  
  double get value => sumNominal;
}

// Model PerformancePoint (sesuai dengan yang ada di chart)
class PerformancePoint {
  final DateTime date;
  final double value;
  
  PerformancePoint(this.date, this.value);
}