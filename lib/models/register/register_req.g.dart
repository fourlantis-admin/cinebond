// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterReq _$RegisterReqFromJson(Map<String, dynamic> json) => RegisterReq(
  email: json['email'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  password: json['password'] as String?,
  phone: json['phone'] as String?,
  GDPRPermission: json['GDPRPermission'] as bool?,
  communicatinoPermissions: json['communicatinoPermissions'] == null
      ? null
      : CommunicationPermissionsReq.fromJson(
          json['communicatinoPermissions'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$RegisterReqToJson(RegisterReq instance) =>
    <String, dynamic>{
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'password': instance.password,
      'phone': instance.phone,
      'GDPRPermission': instance.GDPRPermission,
      'communicatinoPermissions': instance.communicatinoPermissions,
    };
