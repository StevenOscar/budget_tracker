import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static final String _loginKey = "login";
  static final String _usernameKey = "username";

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

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString(_usernameKey) ?? "";
    return username;
  }

  static void setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_usernameKey, username);
  }

  static void deleteUsername() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_usernameKey);
  }
}
