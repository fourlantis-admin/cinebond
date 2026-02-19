import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:dio/dio.dart';
import 'package:cinebond/constants/network/network_constants.dart';
import 'package:cinebond/service/exception/network_exception.dart';

class ResponseHandling {
  StoreManager storeManager = StoreManager();
  dynamic returnResponse(Response response, {bool isAuth = false}) async {
    if (response.data["status"] == ResponseMessage.SUCCESS) {
      if (isAuth == true) {
        String authToken =
            response.headers.map["authorization"]?[0].toString() ?? "";
        await storeManager.saveToken(authToken);
      }

      return response.data["data"];
    } else {
      if (response.data["status"] == ResponseMessage.FAIL) {
        handleExceptions(response);
      } else {
        handleDioException(response);
      }
    }
  }

  Never handleExceptions(dynamic response) {
    switch (response.statusCode) {
      case ResponseCode.BAD_REQUEST:
        throw NetworkException(
          response.statusCode,
          response.data["error"]["message"],
        );
      case ResponseCode.FORBIDDEN:
        throw NetworkException(
          response.statusCode,
          response.data["error"]["message"],
        );
      case ResponseCode.INTERNAL_SERVER_ERROR:
        throw NetworkException(
          response.statusCode,
          response.data["error"]["message"],
        );
      case ResponseCode.NOT_FOUND:
        throw NetworkException(
          response.statusCode,
          response.data["error"]["message"],
        );
      case ResponseCode.NO_CONTENT:
        throw NetworkException(
          response.statusCode,
          response.data["error"]["message"],
        );
      case ResponseCode.UNAUTHORIZED:
        throw NetworkException(
          response.statusCode,
          response.data["error"]["message"],
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
