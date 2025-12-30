
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/constants/network/network_constants.dart';
import 'package:cinebond/service/exception/network_exception.dart';

class ResponseHandling {

  dynamic returnResponse(var response,BuildContext context) async {
    var result = response.data;
    print(result["status"]);
    if(result["status"] == "SUCCESS"){
     
    }
    else{
      handleExceptions(response,context);
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
  dynamic handleExceptions(var response,BuildContext context) async {
    var result = response.data;
    if (result == null) {
      await handleDioException(response);
    } else {
      await handleOtherExceptions(response,context);
    }
  }

  dynamic handleDioException(var response) async {
    if (response.type == DioExceptionType.connectionError) {
      throw NetworkException(408, ResponseMessage.CONNECT_TIMEOUT);
    } else if (response.type == DioExceptionType.connectionTimeout) {
      throw NetworkException(408, ResponseMessage.CONNECT_TIMEOUT);
    } else if (response.type == DioExceptionType.receiveTimeout) {
      throw NetworkException(408, ResponseMessage.RECIEVE_TIMEOUT);
    } else if (response.type == DioExceptionType.sendTimeout) {
      throw NetworkException(408, ResponseMessage.SEND_TIMEOUT);
    } else if (response.type == DioExceptionType.badCertificate) {
      throw NetworkException(408, ResponseMessage.BAD_CERTIFICATE);
    } else {
      throw NetworkException(408, ResponseMessage.CONNECT_TIMEOUT);
    }
  }

  dynamic handleOtherExceptions(var response, BuildContext context) async {
    var result = response.data;
    print(result["error"]["message"]);
    throw NetworkException(
        404, result["error"]["message"].toString());
  }
}
