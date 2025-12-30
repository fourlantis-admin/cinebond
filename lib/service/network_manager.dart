
import 'package:cinebond/constants/network/network_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/service/exception/response_handling.dart';
class NetworkManager {
  Dio dio = Dio();
  String BASE_URL = "http://10.0.2.2:2626/";
  String BASE_URL_MOVIE = "https://api.themoviedb.org/";
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
      if(response.data["status"] == ResponseMessage.SUCCESS){
        return response.data["data"];
      }
      else{
        throw response;
      }
    } catch (e) {
      print("ERROR *********: " + e.toString());
      await responseHandling.handleExceptions(e,context);
    } finally {
      print("final");
    }
    
  }
    Future<dynamic> getBase(BuildContext context, String urlExtension,
      ) async {
        
    dio.options.connectTimeout = timeoutDuration;
    String url = BASE_URL_MOVIE + urlExtension;
    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      print("RESPONSE *******: " + response.toString());
      return responseHandling.returnResponseMovie(response);
    } catch (e) {
      print("ERROR *********: " + e.toString());
      await responseHandling.handleExceptions(e,context);
    } finally {
      print("final");
    }
    
  }
}
