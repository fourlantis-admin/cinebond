import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cinebond/models/login/login_req.dart';
import 'package:cinebond/service/network_manager.dart';

class LoginRepository {
  NetworkManager manager = NetworkManager();

  //LoginRepository();

  // Future<UrlResponse> getURLs(BuildContext context) async {
  //   try {
  //     final response =
  //         await apiHelper.getMais(context, "api/atlas/atlas-env-settings");
  //     print(response);
  //     return UrlResponse.fromJson(response);
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  //****************************************************************************************************************** */
  //****************************************** VEHICLE **********************************************************
  //****************************************************************************************************************** */
  Future<String> authenticate(
      BuildContext context, LoginReq req) async {
    try {
      final response = await manager.post(
          context, req.toMap(), "user/login");
      print(response);
      return response;
    } catch (e) {
      throw e;
    }
  }
}