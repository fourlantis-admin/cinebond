
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/service/exception/response_handling.dart';
class NetworkManager {
  Dio dio = Dio();
  String BASE_URL = "https://caseapi.servicelabs.tech/";
  Duration timeoutDuration = const Duration(seconds: 7);
  ResponseHandling responseHandling = ResponseHandling();  

  //***************************************************************
  // ********************* POST METHOD *****************************
  Future<dynamic> post(BuildContext context, dynamic data, String urlExtension,
      {bool isAuth = false}) async {
        
    dio.options.connectTimeout = timeoutDuration;
    String url = BASE_URL + urlExtension;
    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      print("RESPONSE *******: " + response.toString());
      return responseHandling.returnResponse(response);
    } catch (e) {
      print("ERROR *********: " + e.toString());
      await responseHandling.handleExceptions(e,context);
    } finally {
      print("final");
    }
    
  }
}
