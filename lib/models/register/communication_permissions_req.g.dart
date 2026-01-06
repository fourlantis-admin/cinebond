// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communication_permissions_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunicationPermissionsReq _$CommunicationPermissionsReqFromJson(
  Map<String, dynamic> json,
) => CommunicationPermissionsReq(
  phone: json['phone'] as bool?,
  sms: json['sms'] as bool?,
  email: json['email'] as bool?,
);

Map<String, dynamic> _$CommunicationPermissionsReqToJson(
  CommunicationPermissionsReq instance,
) => <String, dynamic>{
  'phone': instance.phone,
  'sms': instance.sms,
  'email': instance.email,
};
