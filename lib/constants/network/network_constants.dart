
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
  static const String SUCCESS = "success"; // success with data
  static const String NO_CONTENT =  "success with not content";// success with no data (no content)
  static const String BAD_REQUEST =   "Kötü istek. tekrar deneyin veya yetkili bir kişiyle görüşün";// failure, API rejected request
  static const String UNAUTHORIZED = "Kullanıcı yetkisi bulunmamakta, tekrar deneyin veya yetkili bir kişiyle görüşün"; // failure, user is not authorised
  static const String FORBIDDEN ="Forbidden request. try again later";//  failure, API rejected request
  static const String INTERNAL_SERVER_ERROR = "Bir sorun oluştu, tekrar deneyin veya yetkili bir kişiyle görüşün"; // failure, crash in server side
  static const String NOT_FOUND ="Bulunamadı, tekrar deneyin veya yetkili bir kişiyle görüşün"; // failure, crash in server side
  static const String EXPIRED_TOKEN ="Oturum süreniz dolmuştur. Tekrar giriş yapın"; // failure, crash in server side

  static const String CONNECT_TIMEOUT = "Bağlantı Hatası, tekrar deneyin veya yetkili bir kişiyle görüşün";
  static const String CANCEL = "İptal edildi, tekrar deneyin veya yetkili bir kişiyle görüşün";
  static const String RECIEVE_TIMEOUT = "Bağlantı Hatası, tekrar deneyin veya yetkili bir kişiyle görüşün";
  static const String SEND_TIMEOUT = "Bağlantı Hatası, tekrar deneyin veya yetkili bir kişiyle görüşün";
  static const String BAD_CERTIFICATE = "Kötü sertifika, tekrar deneyin veya yetkili bir kişiyle görüşün";
}