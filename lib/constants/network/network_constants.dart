
class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404;
  static const int UNAUTHORIZED= 401; //token expired
}
class ResponseMessage {
  static const String SUCCESS = "SUCCESS"; 
  static const String FAIL = "FAIL"; 
  static const String CONNECT_TIMEOUT = "Bağlantı Hatası, daha sonra tekrar deneyiniz.";
}