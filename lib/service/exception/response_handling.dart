
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/constants/network/network_constants.dart';
import 'package:cinebond/service/exception/network_exception.dart';

class ResponseHandling {

  dynamic returnResponse(var response) async {
    print(response);
    switch (response.statusCode) {
      //200 SUCCESS
      //********************* */
      case ResponseCode.SUCCESS:
        return response.data;
    }
  }
  dynamic handleExceptions(var response,BuildContext context) async {
    if (response.response == null) {
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
    switch (response.response.statusCode) {
      //400 BAD_REQUEST
      case ResponseCode.BAD_REQUEST:
        throw NetworkException(
            response.response.statusCode, response.response.data["title"]);
      //403 FORBIDDEN
      case ResponseCode.FORBIDDEN:
        throw NetworkException(
            response.response.statusCode, response.response.data["title"]);

      //500 INTERNAL_SERVER_ERROR
      case ResponseCode.INTERNAL_SERVER_ERROR:
        throw NetworkException(
            response.response.statusCode, response.response.data["title"]);
      //404 NOT_FOUND
      case ResponseCode.NOT_FOUND:
        throw NetworkException(
            response.response.statusCode, response.response.data["title"]);
    }
  }

  //***************************************************************************** */
  //***************************************************************************** */
  //***************************************************************************** */
  //ATLAS DMS HANDLINGS
  //***************************************************************************** */
  //***************************************************************************** */
  //***************************************************************************** */
  dynamic returnResponseAtlas(var response, BuildContext context) async {
    var result = response.data;
    switch (result["statusCode"]) {
      case ResponseCode.SUCCESS:
        return response.data["data"];
      case ResponseCode.UNAUTHORIZED:
      case 0:
        throw NetworkException(0, result["resultMessage"]);
      default:
        throw NetworkException(408, ResponseMessage.CONNECT_TIMEOUT);
    }
  }

  dynamic handleExceptionAtlas(var exception,context) async {
    print(exception.runtimeType);
    if (exception?.runtimeType == DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionError:
          throw NetworkException(408, ResponseMessage.CONNECT_TIMEOUT);
        case DioExceptionType.connectionTimeout:
          throw NetworkException(408, ResponseMessage.CONNECT_TIMEOUT);
        case DioExceptionType.receiveTimeout:
          throw NetworkException(408, ResponseMessage.CONNECT_TIMEOUT);
        case DioExceptionType.sendTimeout:
          throw NetworkException(408, ResponseMessage.CONNECT_TIMEOUT);
        case DioExceptionType.badCertificate:
          throw NetworkException(408, ResponseMessage.CONNECT_TIMEOUT);
        default:
          throw NetworkException(408, ResponseMessage.CONNECT_TIMEOUT);
      }
    } else {
      throw exception;
    }
  }
}
