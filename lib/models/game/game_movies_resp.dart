import 'package:json_annotation/json_annotation.dart';

part 'game_movies_resp.g.dart';

@JsonSerializable(includeIfNull: true)
class GameMoviesResp {
  final int id;
  final String title;
  final String posterUrl;
  final List<String> emoji;
  final int year;
  final String genre;
  final List<String> cast;

  GameMoviesResp({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.cast,
    required this.emoji,
    required this.year,
    required this.genre,
  });

  factory GameMoviesResp.fromJson(Map<String, dynamic> json) =>
      _$GameMoviesRespFromJson(json);

  Map<String, dynamic> toJson() => _$GameMoviesRespToJson(this);

}