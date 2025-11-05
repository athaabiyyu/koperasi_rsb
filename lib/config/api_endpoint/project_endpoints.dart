import '../api_config.dart';

class ProjectEndpoints {
  static final String base = '${ApiConfig.baseUrl}/project';
  static final String categoryBase = '${ApiConfig.baseUrl}/project-category';

  // Project endpoints
  static String getProjectDetail(String projectId) {
    return '$base/$projectId';
  }

  static String getUserProjects() {
    return '$base/user';
  }

  static String getAllProjects() {
    return base;
  }

  static String createProject() {
    return base;
  }

  static String updateProject() {
    return '$base/update';
  }

  // Agreement endpoints
  static String signAgreementLetter() {
    return '$base/agreement-letter';
  }

  static String getAgreementByProjectId(String projectId) {
    return '$base/$projectId/agreement-letter';
  }

  // Investor endpoints
  static String getProjectInvestors(String projectId) {
    return '$base/$projectId/user';
  }

  // Category endpoints
  static String getProjectCategories() {
    return categoryBase;
  }
}