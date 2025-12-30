// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieResp _$MovieRespFromJson(Map<String, dynamic> json) => MovieResp(
  adult: json['adult'] as bool?,
  backdrop_path: json['backdrop_path'] as String?,
  id: (json['id'] as num?)?.toInt(),
  original_language: json['original_language'] as String?,
  original_title: json['original_title'] as String?,
  overview: json['overview'] as String?,
  popularity: (json['popularity'] as num?)?.toDouble(),
  poster_path: json['poster_path'] as String?,
  release_date: json['release_date'] as String?,
  title: json['title'] as String?,
  video: json['video'] as bool?,
  vote_average: (json['vote_average'] as num?)?.toDouble(),
  vote_count: (json['vote_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$MovieRespToJson(MovieResp instance) => <String, dynamic>{
  'adult': instance.adult,
  'backdrop_path': instance.backdrop_path,
  'id': instance.id,
  'original_language': instance.original_language,
  'original_title': instance.original_title,
  'overview': instance.overview,
  'popularity': instance.popularity,
  'poster_path': instance.poster_path,
  'release_date': instance.release_date,
  'title': instance.title,
  'video': instance.video,
  'vote_average': instance.vote_average,
  'vote_count': instance.vote_count,
};
