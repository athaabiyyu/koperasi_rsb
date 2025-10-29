import 'package:flutter_dotenv/flutter_dotenv.dart';

class UrlHelper {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3000';

  static String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://via.placeholder.com/400x300?text=No+Image';
    }
    
    // Jika sudah full URL (http:// atau https://), return as is
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    
    // Remove file:/// prefix jika ada
    if (path.startsWith('file:///')) {
      path = path.replaceFirst('file:///', '');
    }
    
    // Remove leading slash jika ada
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    
    // Build full URL
    return '$baseUrl/$path';
  }
  
  /// Check if URL is valid image URL
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  }
  
  /// Get file extension from URL
  static String? getFileExtension(String? url) {
    if (url == null || url.isEmpty) return null;
    
    final lastDot = url.lastIndexOf('.');
    if (lastDot == -1) return null;
    
    return url.substring(lastDot + 1).toLowerCase();
  }
  
  /// Check if URL is image by extension
  static bool isImageByExtension(String? url) {
    final ext = getFileExtension(url);
    if (ext == null) return false;
    
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
    return imageExtensions.contains(ext);
  }
}