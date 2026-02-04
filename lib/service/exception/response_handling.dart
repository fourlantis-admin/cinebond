import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/constants/network/network_constants.dart';
import 'package:cinebond/service/exception/network_exception.dart';

class ResponseHandling {
  StoreManager storeManager = StoreManager();
  dynamic returnResponse(
    Response response,
    BuildContext context, {
    bool isAuth = false,
  }) async {
    if (response.data["status"] == ResponseMessage.SUCCESS) {
      if (isAuth == true) {
        String authToken =
            response.headers.map["authorization"]?[0].toString() ?? "";
        await storeManager.saveToken(authToken);
      }

      return response.data["data"];
    } else {
      handleExceptions(response, context);
    }
  }

  dynamic returnResponseMovie(var response) async {
    print(response);
    switch (response.statusCode) {
      //200 SUCCESS
      //********************* */
      case ResponseCode.SUCCESS:
        return response.data;
    }
  }

  Never handleExceptions(dynamic response, BuildContext context) {
    if (response.response == null) {
      handleDioException(response);
    }

    switch (response.response.statusCode) {
      case ResponseCode.BAD_REQUEST:
      case ResponseCode.FORBIDDEN:
      case ResponseCode.INTERNAL_SERVER_ERROR:
      case ResponseCode.NOT_FOUND:
      case ResponseCode.NO_CONTENT:
      case ResponseCode.UNAUTHORIZED:
        throw NetworkException(
          response.response.statusCode,
          response.response.data["error"]["message"],
        );
      default:
        throw NetworkException(500, "Bilinmeyen hata");
    }
  }

  Never handleDioException(dynamic response) {
    if (response.type == DioExceptionType.connectionError ||
        response.type == DioExceptionType.connectionTimeout) {
      throw NetworkException(408, ResponseMessage.CONNECT_TIMEOUT);
    }

    throw NetworkException(408, ResponseMessage.CONNECT_TIMEOUT);
  }
}
