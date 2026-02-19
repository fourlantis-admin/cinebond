import 'package:cinebond/controller/movie/movie_detail_cubit.dart';
import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_resp.g.dart';

@JsonSerializable(includeIfNull: true)
class LoginResp {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? phone;
  final String? lastLoginAt;
  final String? createdAt;
  final String? updatedAt;
  final List<MovieResp>? favoriteMovies;
  LoginResp({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.phone,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.favoriteMovies
  });

  factory LoginResp.fromJson(Map<String, dynamic> json) =>
      _$LoginRespFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRespToJson(this);

}