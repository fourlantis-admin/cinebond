import 'package:json_annotation/json_annotation.dart';

part 'login_req.g.dart';

@JsonSerializable(includeIfNull: true)
class LoginReq {
  final String? username;
  final String? password;


  LoginReq({
    this.username,
    this.password,
  });

  factory LoginReq.fromJson(Map<String, dynamic> json) =>
      _$LoginReqFromJson(json);

  Map<String, dynamic> toJson() => _$LoginReqToJson(this);

  Map<String, dynamic> toMap() {
    return {
      "email": username,
      "password": password,
    };
  }
}