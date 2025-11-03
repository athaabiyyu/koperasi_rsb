class HistoryProject {
  final String id;
  final String idProjek;
  final String history;
  final String? keterangan;
  final String status; // SUCCESS, FAILED, PENDING
  final DateTime createdAt;
  final DateTime? updatedAt;

  HistoryProject({
    required this.id,
    required this.idProjek,
    required this.history,
    this.keterangan,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory HistoryProject.fromJson(Map<String, dynamic> json) {
    return HistoryProject(
      id: json['id'] ?? '',
      idProjek: json['id_projek'] ?? '',
      history: json['history'] ?? '',
      keterangan: _stripHtmlTags(json['keterangan']), // ✅ Strip HTML tags
      status: json['status'] ?? 'PENDING',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // ✅ Helper method to strip HTML tags
  static String? _stripHtmlTags(dynamic htmlString) {
    if (htmlString == null) return null;

    final text = htmlString.toString();

    // Remove HTML tags
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    String result = text.replaceAll(exp, '');

    // Decode HTML entities
    result = result
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'")
        .replaceAll('<br>', '\n')
        .replaceAll('<br/>', '\n')
        .replaceAll('<br />', '\n');

    // Clean up extra whitespace
    result = result.trim();

    return result.isEmpty ? null : result;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_projek': idProjek,
      'history': history,
      'keterangan': keterangan,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters
  bool get isSuccess => status == 'SUCCESS';
  bool get isFailed => status == 'FAILED';
  bool get isPending => status == 'PENDING';

  // Convert to TimelineStatus format for UI
  Map<String, dynamic> toTimelineEvent() {
    return {
      'type': status.toLowerCase(),
      'message': keterangan ?? '',
      'date': _formatDate(createdAt),
    };
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    // ✅ Convert to WIB (GMT+7)
    final wibDate = date.toUtc().add(const Duration(hours: 7));

    return '${wibDate.day} ${months[wibDate.month - 1]} ${wibDate.year}, ${wibDate.hour}:${wibDate.minute.toString().padLeft(2, '0')}';
  }
}

// Helper class untuk grouping history by step
class TimelineStepData {
  final String stepName;
  final List<HistoryProject> histories;
  final int stepIndex;

  TimelineStepData({
    required this.stepName,
    required this.histories,
    required this.stepIndex,
  });

  // Get latest history for this step (newest first)
  HistoryProject? get latestHistory {
    if (histories.isEmpty) return null;
    final sorted = List<HistoryProject>.from(histories);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.first;
  }

  // Get overall step status
  String get overallStatus {
    if (histories.isEmpty) return 'UPCOMING';

    // ✅ If ANY history is SUCCESS, mark as success (even if there was FAILED before)
    if (histories.any((h) => h.isSuccess)) return 'SUCCESS';

    // ❌ If any failed (and no success), mark as failed
    if (histories.any((h) => h.isFailed)) return 'FAILED';

    // ⏳ If has pending, mark as pending
    if (histories.any((h) => h.isPending)) return 'PENDING';

    return 'UPCOMING';
  }

  bool get hasHistories => histories.isNotEmpty;
  bool get isSuccess => overallStatus == 'SUCCESS';
  bool get isFailed => overallStatus == 'FAILED';
  bool get isPending => overallStatus == 'PENDING';
  bool get isUpcoming => overallStatus == 'UPCOMING';

  // ✅ Convert to timeline events format for UI (OLDEST to NEWEST)
  List<Map<String, dynamic>> toTimelineEvents() {
    // Sort histories from oldest to newest
    final sortedHistories = List<HistoryProject>.from(histories);
    sortedHistories.sort(
        (a, b) => a.createdAt.compareTo(b.createdAt)); // ✅ Ascending order

    return sortedHistories.map((h) => h.toTimelineEvent()).toList();
  }
}
