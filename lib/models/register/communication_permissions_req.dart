import 'package:json_annotation/json_annotation.dart';

part 'communication_permissions_req.g.dart';

@JsonSerializable(includeIfNull: true)
class CommunicationPermissionsReq {
  final bool? phone;
  final bool? sms;
  final bool? email;
  // "email": "john.doe@example.com",
//   "password": "SecurePass123!",
//   "phone": "+1234567890",
//   "GDPRPermission": true,
//   "communicationPermissions": {
//     "phone": true,
//     "sms": false,
//     "email": true
//   }

  CommunicationPermissionsReq({
    this.phone,
    this.sms,
    this.email
  });

  factory CommunicationPermissionsReq.fromJson(Map<String, dynamic> json) =>
      _$CommunicationPermissionsReqFromJson(json);

  Map<String, dynamic> toJson() => _$CommunicationPermissionsReqToJson(this);

}