class TimelineStatus {
  final String id;
  final String history;
  final String status; // SUCCESS, FAILED, CURRENT, PENDING, UPCOMING
  final String keterangan;
  final DateTime createdAt;

  TimelineStatus({
    required this.id,
    required this.history,
    required this.status,
    required this.keterangan,
    required this.createdAt,
  });

  factory TimelineStatus.fromJson(Map<String, dynamic> json) {
    return TimelineStatus(
      id: json['id'] ?? '',
      history: json['history'] ?? '',
      status: json['status'] ?? 'UPCOMING',
      keterangan: json['keterangan'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  bool get isSuccess => status == 'SUCCESS';
  bool get isFailed => status == 'FAILED';
  bool get isCurrent => status == 'CURRENT';
  bool get isPending => status == 'PENDING';
  bool get isUpcoming => status == 'UPCOMING';
}

class TimelineStep {
  final String stepName;
  final List<TimelineStatus> events;
  final int stepIndex;

  TimelineStep({
    required this.stepName,
    required this.events,
    required this.stepIndex,
  });

  // Get the latest status for this step
  TimelineStatus? get latestStatus {
    if (events.isEmpty) return null;
    events.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return events.first;
  }

  // Get overall step status
  String get overallStatus {
    if (events.isEmpty) return 'UPCOMING';
    return latestStatus?.status ?? 'UPCOMING';
  }

  bool get hasEvents => events.isNotEmpty;
  bool get isSuccess => overallStatus == 'SUCCESS';
  bool get isFailed => overallStatus == 'FAILED';
  bool get isCurrent => overallStatus == 'CURRENT';
  bool get isPending => overallStatus == 'PENDING';
  bool get isUpcoming => overallStatus == 'UPCOMING';
}