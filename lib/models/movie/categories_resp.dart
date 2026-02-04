import 'package:json_annotation/json_annotation.dart';

part 'categories_resp.g.dart';

@JsonSerializable(includeIfNull: true)
class CategoriesResp{
  double? id;
  String? name;



  CategoriesResp({
   this.id,
   this.name
  });

  factory CategoriesResp.fromJson(Map<String, dynamic> json) =>
      _$CategoriesRespFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesRespToJson(this);

}