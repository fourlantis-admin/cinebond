
import 'package:cinebond/models/movie/categories_resp.dart';
import 'package:json_annotation/json_annotation.dart';

part 'actors_resp.g.dart';
@JsonSerializable(includeIfNull: true)
class ActorsResp{
  double? id;
  String? name;
  double? birthYear;
  String? imageUrl;


  ActorsResp({
    this.id,
    this.name,
    this.birthYear,
    this.imageUrl,

  });

  factory ActorsResp.fromJson(Map<String, dynamic> json) =>
      _$ActorsRespFromJson(json);

  Map<String, dynamic> toJson() => _$ActorsRespToJson(this);

}