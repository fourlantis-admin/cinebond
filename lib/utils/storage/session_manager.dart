import 'package:cinebond/models/login/login_resp.dart';
import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:flutter/material.dart';

class SessionManager {
  static SessionManager? _instance;
  SessionManager._internal();

  factory SessionManager() {
    _instance ??= SessionManager._internal();
    return _instance!;
  }

  final ValueNotifier<LoginResp?> userNotifier = ValueNotifier<LoginResp?>(null);
  String? authToken;
  LoginResp? get user => userNotifier.value;

  void setUser(LoginResp user) {
    userNotifier.value = user;
  }

  void clearUser() {
    userNotifier.value = null;
  }

  Future<void> loadUserInfo() async {
    var store = StoreManager();
    final loadedUser = await store.getUser();
    authToken = await store.getToken();

    if (loadedUser != null) {
      userNotifier.value = loadedUser;
    }

    print(user);
    print(authToken);
  }
}