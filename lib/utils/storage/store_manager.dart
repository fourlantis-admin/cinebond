import 'dart:convert';
import 'package:cinebond/models/login/login_resp.dart';
import 'package:cinebond/utils/storage/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreManager {
  static const String USER_RESP = 'user_info';
  static const String AUTH_TOKEN = 'auth_token';

  //***************************** */
  //USER OPERATIONS HERE
  //***************************** */
  Future saveUser(LoginResp? resp) async {
    var session = SessionManager();
    SharedPreferences.getInstance().then((prefs) async {
      var info = json.encode(resp?.toJson());
      await prefs.setString(USER_RESP, info);
      print(prefs);
      session.loadUserInfo();
    });
  }

  Future<LoginResp>? getUser() async {
    var shared = await SharedPreferences.getInstance();
    String? data = await shared.getString(USER_RESP);
    if(data == null)
      return LoginResp();
    
    final user = LoginResp.fromJson(json.decode(data ?? ""));
    print(user);
    return user;
  }
  Future removeUserInfo() async {
    var session = SessionManager();
    SharedPreferences.getInstance().then((prefs) async {
      await prefs.remove(USER_RESP);
      session.loadUserInfo();
    });
  }

  Future<String>? getToken() async {
    var shared = await SharedPreferences.getInstance();
    var data;
    try {
      data = await shared.getString(AUTH_TOKEN);
    } catch (e) {
      print(e);
    }
    print(data);
    return data ?? "";
  }

  Future saveToken(String token) async {
    var session = SessionManager();
    SharedPreferences.getInstance().then((prefs) async {
      await prefs.setString(AUTH_TOKEN, token);
      print(prefs);
      session.loadUserInfo();
    });
  }
    Future removeToken() async {
    var session = SessionManager();
    SharedPreferences.getInstance().then((prefs) async {
      await prefs.remove(AUTH_TOKEN);
      session.loadUserInfo();
    });
  }
}
