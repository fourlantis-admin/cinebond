// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_by_id_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericByIdReq _$GenericByIdReqFromJson(Map<String, dynamic> json) =>
    GenericByIdReq(
      id: json['id'] as String?,
      idInt: (json['idInt'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GenericByIdReqToJson(GenericByIdReq instance) =>
    <String, dynamic>{'idInt': instance.idInt, 'id': instance.id};
