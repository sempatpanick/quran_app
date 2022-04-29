import 'package:json_annotation/json_annotation.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel {
  bool status;
  String message;
  List<DataFavorite>? data;

  FavoriteModel({
    required this.status,
    required this.message,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => _$FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);
}

@JsonSerializable()
class DataFavorite {
  String id;
  @JsonKey(name: 'id_user')
  String idUser;
  @JsonKey(name: 'number_surah')
  String numberSurah;
  @JsonKey(name: 'created_at')
  String createdAt;

  DataFavorite({
    required this.id,
    required this.idUser,
    required this.numberSurah,
    required this.createdAt
  });

  factory DataFavorite.fromJson(Map<String, dynamic> json) => _$DataFavoriteFromJson(json);

  Map<String, dynamic> toJson() => _$DataFavoriteToJson(this);
}