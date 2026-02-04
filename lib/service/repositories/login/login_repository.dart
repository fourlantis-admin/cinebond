import 'package:cinebond/models/login/login_resp.dart';
import 'package:cinebond/models/register/register_req.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cinebond/models/login/login_req.dart';
import 'package:cinebond/service/network_manager.dart';

class LoginRepository {
  NetworkManager manager = NetworkManager();
  LoginRepository();


  Future<LoginResp> login(
      BuildContext context, LoginReq req) async {
    try {
      final response = await manager.post(
          context, req.toMap(), "api/auth/login",isAuth: true);
      print(response);
      return LoginResp.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
  Future<LoginResp> register(
      BuildContext context, RegisterReq req) async {
    try {
      final response = await manager.post(
          context, req, "api/users/register");
      print(response);
      return LoginResp.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}