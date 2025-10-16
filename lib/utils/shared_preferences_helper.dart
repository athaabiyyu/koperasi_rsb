import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _tokenKey = 'auth_token';
  static const String _rememberMeKey = 'remember_me';
  static const String _userNameKey = 'user_name';
  static const String _noHpKey = 'saved_no_hp';
  static const String _passwordKey = 'saved_password';
  static const String _userStatusKey = 'user_status'; // ⭐ TAMBAHAN untuk status

  // ========== TOKEN METHODS ==========
  
  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Remove token
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ========== REMEMBER ME METHODS ==========
  
  // Save credentials (Remember Me)
  static Future<void> saveCredentials({
    required String noHp,
    required String password,
    required bool rememberMe,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (rememberMe) {
      await prefs.setBool(_rememberMeKey, true);
      await prefs.setString(_noHpKey, noHp);
      await prefs.setString(_passwordKey, password);
    } else {
      await clearCredentials();
    }
  }

  // Get saved credentials
  static Future<Map<String, dynamic>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    
    if (rememberMe) {
      return {
        'remember_me': true,
        'no_hp': prefs.getString(_noHpKey),
        'password': prefs.getString(_passwordKey),
      };
    }
    
    return {
      'remember_me': false,
      'no_hp': null,
      'password': null,
    };
  }

  // Clear credentials only
  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_noHpKey);
    await prefs.remove(_passwordKey);
  }

  // ========== USER STATUS METHODS ==========
  
  // Save user status
  static Future<void> saveUserStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userStatusKey, status);
  }

  // Get user status
  static Future<String?> getUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userStatusKey);
  }

  // Remove user status
  static Future<void> removeUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userStatusKey);
  }

  // ========== CLEAR ALL ==========
  
  // Clear all data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  // Clear all except remember me (untuk logout tapi tetap ingat kredensial)
  static Future<void> clearAllExceptCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Simpan credentials dulu
    final savedCredentials = await getSavedCredentials();
    
    // Clear semua
    await prefs.clear();
    
    // Restore credentials jika remember me aktif
    if (savedCredentials['remember_me'] == true) {
      await saveCredentials(
        noHp: savedCredentials['no_hp'] ?? '',
        password: savedCredentials['password'] ?? '',
        rememberMe: true,
      );
    }
  }

  // ========== FUNGSI BARU DARI KODE 2 ==========

  /// Check if token exists
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Check if user is logged in (has valid token)
  static Future<bool> isLoggedIn() async {
    return await hasToken();
  }

  /// Get all stored keys (for debugging)
  static Future<Set<String>> getAllKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getKeys();
    } catch (e) {
      print('Error getting all keys: $e');
      return {};
    }
  }

  /// Print all saved data (for debugging)
  static Future<void> printAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      print('=== SHARED PREFERENCES DATA ===');
      for (var key in keys) {
        final value = prefs.get(key);
        // Mask password for security
        if (key == _passwordKey) {
          print('$key: ********');
        } else {
          print('$key: $value');
        }
      }
      print('================================');
    } catch (e) {
      print('Error printing data: $e');
    }
  }
   // ⭐ TAMBAHAN: Save User Name
  static Future<bool> saveUserName(String userName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_userNameKey, userName);
    } catch (e) {
      print('Error saving user name: $e');
      return false;
    }
  }

  // ⭐ TAMBAHAN: Get User Name
  static Future<String?> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userNameKey);
    } catch (e) {
      print('Error getting user name: $e');
      return null;
    }
  }
}