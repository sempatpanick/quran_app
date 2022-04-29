// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteModel _$FavoriteModelFromJson(Map<String, dynamic> json) =>
    FavoriteModel(
      status: json['status'] as bool,
      message: json['message'] as String,
    )..data = (json['data'] as List<dynamic>?)
        ?.map((e) => DataFavorite.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$FavoriteModelToJson(FavoriteModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

DataFavorite _$DataFavoriteFromJson(Map<String, dynamic> json) => DataFavorite(
      id: json['id'] as String,
      idUser: json['id_user'] as String,
      numberSurah: json['number_surah'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$DataFavoriteToJson(DataFavorite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_user': instance.idUser,
      'number_surah': instance.numberSurah,
      'created_at': instance.createdAt,
    };
