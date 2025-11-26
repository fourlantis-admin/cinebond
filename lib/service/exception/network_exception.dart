class NetworkException<T> implements Exception {
  final _statusCode;
  final _message;


  NetworkException([this._statusCode,this._message]);

  String toString() {
    return "$_message";
  }
}