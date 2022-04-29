import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  bool status;
  String message;
  DataAuth? data;

  AuthModel({
    required this.status,
    required this.message,
    this.data
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}

@JsonSerializable()
class DataAuth {
  String id;
  String username;
  String name;
  String? email;
  @JsonKey(name: 'created_at')
  String createdAt;

  DataAuth({
    required this.id,
    required this.username,
    required this.name,
    this.email,
    required this.createdAt,
  });

  factory DataAuth.fromJson(Map<String, dynamic> json) => _$DataAuthFromJson(json);

  Map<String, dynamic> toJson() => _$DataAuthToJson(this);
}