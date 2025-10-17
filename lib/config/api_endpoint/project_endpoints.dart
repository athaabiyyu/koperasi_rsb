import '../api_config.dart';

class ProjectEndpoints {
  static final String createProject = '${ApiConfig.baseUrl}/projects';
  
  static String getProjectById(String projectId) => 
      '${ApiConfig.baseUrl}/projects/$projectId';
  
  static String updateProject(String projectId) => 
      '${ApiConfig.baseUrl}/projects/$projectId';
  
  static final String listProjects = '${ApiConfig.baseUrl}/projects';
}