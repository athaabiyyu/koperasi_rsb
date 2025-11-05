import '../api_config.dart';

class HistoryEndpoints {
  static final String base = '${ApiConfig.baseUrl}/history-project';

  static String getProjectHistory(String projectId) {
    return '$base/project/$projectId';
  }
}