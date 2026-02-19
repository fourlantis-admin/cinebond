// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResp _$LoginRespFromJson(Map<String, dynamic> json) => LoginResp(
  id: json['id'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
  password: json['password'] as String?,
  phone: json['phone'] as String?,
  lastLoginAt: json['lastLoginAt'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  favoriteMovies: (json['favoriteMovies'] as List<dynamic>?)
      ?.map((e) => MovieResp.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LoginRespToJson(LoginResp instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'password': instance.password,
  'phone': instance.phone,
  'lastLoginAt': instance.lastLoginAt,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'favoriteMovies': instance.favoriteMovies,
};
