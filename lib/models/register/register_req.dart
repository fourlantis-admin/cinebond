import 'package:cinebond/models/register/communication_permissions_req.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_req.g.dart';

@JsonSerializable(includeIfNull: true)
class RegisterReq {
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? password;
  final String? phone;
  final bool? GDPRPermission;
  final CommunicationPermissionsReq? communicatinoPermissions;

  RegisterReq({
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.phone,
    this.GDPRPermission,
    this.communicatinoPermissions,

  });

  factory RegisterReq.fromJson(Map<String, dynamic> json) =>
      _$RegisterReqFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterReqToJson(this);

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "password": password,
      "phone": password,
      "GDPRPermission": password,
      "communicatinoPermissions": password,
    };
  }
}