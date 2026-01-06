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
    String url = BASE_URL + urlExtension;
    context.read<LoadingCubit>().show();
    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      print("RESPONSE *******: " + response.toString());
      if (response.data["status"] == ResponseMessage.SUCCESS) {
        String authToken =
            response.headers.map["authorization"]?[0].toString() ?? "";
        await storeManager.saveToken(authToken);
        return response.data["data"];
      } else {
        throw response;
      }
    } catch (e) {
      print("ERROR *********: " + e.toString());
      await responseHandling.handleExceptions(e, context);
    } finally {
      context.read<LoadingCubit>().hide();
      print("final");
    }
  }

  Future<dynamic> getBase(BuildContext context, String urlExtension) async {
    dio.options.connectTimeout = timeoutDuration;
    String url = BASE_URL_MOVIE + urlExtension;
    context.read<LoadingCubit>().show();

    try {
      final response = await dio.get(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      print("RESPONSE *******: " + response.toString());
      return responseHandling.returnResponseMovie(response);
    } catch (e) {
      print("ERROR *********: " + e.toString());
      await responseHandling.handleExceptions(e, context);
    } finally {
      context.read<LoadingCubit>().hide();

      print("final");
    }
  }
}
