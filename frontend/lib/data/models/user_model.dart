import 'dart:convert';

class UserModel {
  bool? success;
  String? message;
  UserData? data;

  UserModel({
    this.success,
    this.message,
    this.data,
  });

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserData {
  int? id;
  String? password;
  String? name;
  String? email;
  String? role;

  UserData({
    this.id,
    this.password,
    this.name,
    this.email,
    this.role,
  });

  factory UserData.fromRawJson(String str) =>
      UserData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        password: json["password"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "password": password,
        "name": name,
        "email": email,
        "role": role,
      };
}
