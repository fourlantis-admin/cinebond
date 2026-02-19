import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'generic_by_id_req.g.dart';

@JsonSerializable(includeIfNull: true)
class GenericByIdReq {
  final int? idInt;
  final String? id;

  GenericByIdReq({
    this.id,
    this.idInt
  });

  factory GenericByIdReq.fromJson(Map<String, dynamic> json) =>
      _$GenericByIdReqFromJson(json);

  Map<String, dynamic> toJson() => _$GenericByIdReqToJson(this);

  Map<String, dynamic> toMapMovieId() {
    return {
      "movieId": idInt,
    };
  }
  Map<String, dynamic> toMapId() {
    return {
      "id": id,
    };
  }
  Map<String, dynamic> toMapImageUrl() {
    return {
      "imageUrl": id,
    };
  }
}