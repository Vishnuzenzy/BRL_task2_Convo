import 'package:shared_preferences/shared_preferences.dart';

class LocalSessionService {
  static const String _keyLastLogin = 'last_login_timestamp';
  static const String _keyLoginMethod = 'login_method';

  // Save app-specific session metadata on login
  Future<void> saveSessionData({required String loginMethod}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLoginMethod, loginMethod);
    await prefs.setString(_keyLastLogin, DateTime.now().toIso8601String());
  }

  // Retrieve saved session metadata
  Future<Map<String, String?>> getSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'loginMethod': prefs.getString(_keyLoginMethod),
      'lastLogin': prefs.getString(_keyLastLogin),
    };
  }

  // Clear data on logout (Strict requirement from task doc)
  Future<void> clearSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoginMethod);
    await prefs.remove(_keyLastLogin);
  }
}