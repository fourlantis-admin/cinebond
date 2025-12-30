
import 'package:json_annotation/json_annotation.dart';



part 'movie_resp.g.dart';
@JsonSerializable(includeIfNull: true)
class MovieResp{
  bool? adult;
  String? backdrop_path;
  int? id;
  String? original_language;
  String? original_title;
  String? overview;
  double? popularity;
  String? poster_path;
  String? release_date;
  String? title;
  bool? video;
  double? vote_average;
  int? vote_count;


  MovieResp({
    this.adult,
    this.backdrop_path,
    this.id,
    this.original_language,
    this.original_title,
    this.overview,
    this.popularity,
    this.poster_path,
    this.release_date,
    this.title,
    this.video,
    this.vote_average,
    this.vote_count
  });

  factory MovieResp.fromJson(Map<String, dynamic> json) =>
      _$MovieRespFromJson(json);

  Map<String, dynamic> toJson() => _$MovieRespToJson(this);

}