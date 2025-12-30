import 'package:json_annotation/json_annotation.dart';
part 'error_resp.g.dart';

@JsonSerializable(includeIfNull: false)

class ErrorResp{
   String? error;
   String? error_description;

  ErrorResp({this.error, this.error_description});

  factory ErrorResp.fromJson(Map<String, dynamic> json) =>
      _$ErrorRespFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorRespToJson(this);
}
