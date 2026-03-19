// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_movies_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameMoviesResp _$GameMoviesRespFromJson(Map<String, dynamic> json) =>
    GameMoviesResp(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      posterUrl: json['posterUrl'] as String,
      cast: (json['cast'] as List<dynamic>).map((e) => e as String).toList(),
      emoji: (json['emoji'] as List<dynamic>).map((e) => e as String).toList(),
      year: (json['year'] as num).toInt(),
      genre: json['genre'] as String,
    );

Map<String, dynamic> _$GameMoviesRespToJson(GameMoviesResp instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'posterUrl': instance.posterUrl,
      'emoji': instance.emoji,
      'year': instance.year,
      'genre': instance.genre,
      'cast': instance.cast,
    };
