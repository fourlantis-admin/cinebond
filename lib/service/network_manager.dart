import 'package:cinebond/constants/network/network_constants.dart';
import 'package:cinebond/utils/loading/loading_cubit.dart';
import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/service/exception/response_handling.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkManager {
  Dio dio = Dio();
  String BASE_URL = "http://10.0.2.2:2626/";
  String BASE_URL_MOVIE = "https://api.themoviedb.org/";
  Duration timeoutDuration = const Duration(seconds: 7);
  ResponseHandling responseHandling = ResponseHandling();
  var responseJson;
  StoreManager storeManager = StoreManager();
  //***************************************************************
  // ********************* POST METHOD *****************************
  Future<dynamic> post(
    BuildContext context,
    dynamic data,
    String urlExtension, {
    bool isAuth = false,
  }) async {
    dio.options.connectTimeout = timeoutDuration;
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
    String url = BASE_URL + urlExtension;
    context.read<LoadingCubit>().show();
    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      print("RESPONSE *******: " + response.toString());
      responseJson = await responseHandling.returnResponse(response, context,isAuth: isAuth);
    } catch (e) {
      await responseHandling.handleExceptions(e, context);
    } finally {
      context.read<LoadingCubit>().hide();
    }
    return responseJson;
  }

   Future<dynamic> get(
    BuildContext context,
    String urlExtension, {
    bool isAuth = false,
  }) async {
    dio.options.connectTimeout = timeoutDuration;
    var store = StoreManager();
    String url = BASE_URL + urlExtension;
    context.read<LoadingCubit>().show();
    try {
      final response = await dio.get(
        url,
        options: Options(headers: {"Content-Type": "application/json","Authorization":"Bearer ${await store.getToken()}"}),
      );
      print("RESPONSE *******: " + response.toString());
      responseJson = await responseHandling.returnResponse(response, context);
    } catch (e) {
      await responseHandling.handleExceptions(e, context);
    } finally {
      context.read<LoadingCubit>().hide();
    }
    return responseJson;
  }
}
