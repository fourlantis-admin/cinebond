import 'package:cinebond/models/login/login_resp.dart';
import 'package:cinebond/models/register/register_req.dart';
import 'package:cinebond/models/user/generic_by_id_req.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/models/login/login_req.dart';
import 'package:cinebond/service/network_manager.dart';

class UserRepository {
  NetworkManager manager = NetworkManager();
  UserRepository();


  Future<LoginResp> login(
     LoginReq req) async {
    try {
      final response = await manager.post(
       req.toMap(), "api/auth/login",isAuth: true);
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
       req, "api/users/register");
      print(response);
      return LoginResp.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
  Future<LoginResp> setProfilePicture(
    GenericByIdReq req) async {
    try {
      final response = await manager.put(
       req.toMapImageUrl(), "api/profile/profile-picture");
      print(response);
      return LoginResp.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
  Future<LoginResp> getUserProfile(
      BuildContext context,String userId) async {
    try {
      final response = await manager.get(
         "api/users/${userId}");
      print(response);
      return LoginResp.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}