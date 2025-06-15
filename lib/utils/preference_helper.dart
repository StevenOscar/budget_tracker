import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static final String _loginKey = "login";
  static final String _userIdKey = "user_id";

  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool(_loginKey) ?? false;
    return isLogin;
  }

  static void setLogin(bool login) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loginKey, login);
  }

  static void deleteLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_loginKey);
  }

  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(_userIdKey) ?? 0;
    return userId;
  }

  static void setUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_userIdKey, userId);
  }

  static void deleteUserId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_userIdKey);
  }
}
