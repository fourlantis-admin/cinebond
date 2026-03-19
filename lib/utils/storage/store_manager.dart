import 'dart:convert';
import 'package:cinebond/models/login/login_resp.dart';
import 'package:cinebond/utils/storage/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
class StoreManager {
  static const String USER_RESP = 'user_info';
  static const String AUTH_TOKEN = 'auth_token';

  Future<void> saveUser(LoginResp? resp) async {
    final prefs = await SharedPreferences.getInstance();
    final info = json.encode(resp?.toJson());
    await prefs.setString(USER_RESP, info);
    await SessionManager().loadUserInfo(); // ← await ile sıralı çalışır
  }

  Future<LoginResp?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(USER_RESP);
    if (data == null || data.isEmpty) return null;
    return LoginResp.fromJson(json.decode(data));
  }

  Future<void> removeUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(USER_RESP);
    await SessionManager().loadUserInfo();
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AUTH_TOKEN) ?? "";
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AUTH_TOKEN, token);
    await SessionManager().loadUserInfo();
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AUTH_TOKEN);
    await SessionManager().loadUserInfo();
  }
}