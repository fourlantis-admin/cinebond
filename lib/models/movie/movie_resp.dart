
import 'package:cinebond/models/movie/categories_resp.dart';
import 'package:json_annotation/json_annotation.dart';


part 'movie_resp.g.dart';
@JsonSerializable(includeIfNull: true)
class MovieResp{
  int? id;
  String? name;
  double? duration;
  double? year;
  String? imageUrl;
  String? rating;
  String? description;
  String? updatedAt;
  List<CategoriesResp>? categories;
  bool? isFavorite;

  MovieResp({
    this.id,
    this.name,
    this.duration,
    this.year,
    this.imageUrl,
    this.rating,
    this.description,
    this.updatedAt,
    this.categories,
    this.isFavorite
  });

  factory MovieResp.fromJson(Map<String, dynamic> json) =>
      _$MovieRespFromJson(json);

  Map<String, dynamic> toJson() => _$MovieRespToJson(this);

}