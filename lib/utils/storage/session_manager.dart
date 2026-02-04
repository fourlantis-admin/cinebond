

import 'package:cinebond/models/login/login_resp.dart';
import 'package:cinebond/utils/storage/store_manager.dart';

class SessionManager {
  LoginResp? user;
  String? authToken;

  static SessionManager? _instance;
  SessionManager._internal();

  loadUserInfo() async {
    var store = StoreManager();
    user = await store.getUser();
    authToken = await store.getToken();
    print(user);
    print(authToken);
  }






































  

   factory SessionManager() {
    if (_instance == null) {
      _instance = SessionManager._internal();
    }
    return _instance!;
  }
}