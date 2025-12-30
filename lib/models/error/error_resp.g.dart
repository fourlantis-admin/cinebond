// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResp _$ErrorRespFromJson(Map<String, dynamic> json) => ErrorResp(
  error: json['error'] as String?,
  error_description: json['error_description'] as String?,
);

Map<String, dynamic> _$ErrorRespToJson(ErrorResp instance) => <String, dynamic>{
  'error': ?instance.error,
  'error_description': ?instance.error_description,
};
