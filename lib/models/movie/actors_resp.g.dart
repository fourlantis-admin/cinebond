// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actors_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActorsResp _$ActorsRespFromJson(Map<String, dynamic> json) => ActorsResp(
  id: (json['id'] as num?)?.toDouble(),
  name: json['name'] as String?,
  birthYear: (json['birthYear'] as num?)?.toDouble(),
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$ActorsRespToJson(ActorsResp instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthYear': instance.birthYear,
      'imageUrl': instance.imageUrl,
    };
