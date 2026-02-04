// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieResp _$MovieRespFromJson(Map<String, dynamic> json) => MovieResp(
  id: (json['id'] as num?)?.toDouble(),
  name: json['name'] as String?,
  duration: (json['duration'] as num?)?.toDouble(),
  year: (json['year'] as num?)?.toDouble(),
  imageUrl: json['imageUrl'] as String?,
  rating: json['rating'] as String?,
  description: json['description'] as String?,
  updatedAt: json['updatedAt'] as String?,
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => CategoriesResp.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MovieRespToJson(MovieResp instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'duration': instance.duration,
  'year': instance.year,
  'imageUrl': instance.imageUrl,
  'rating': instance.rating,
  'description': instance.description,
  'updatedAt': instance.updatedAt,
  'categories': instance.categories,
};
