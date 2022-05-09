// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JuzListModel _$JuzListModelFromJson(Map<String, dynamic> json) => JuzListModel(
      juz: (json['juz'] as List<dynamic>)
          .map((e) => DataJuzList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JuzListModelToJson(JuzListModel instance) =>
    <String, dynamic>{
      'juz': instance.juz,
    };

DataJuzList _$DataJuzListFromJson(Map<String, dynamic> json) => DataJuzList(
      id: json['id'] as int,
      juzNumber: json['juz_number'] as int,
      verseMapping: (json['verse_mapping'] as List<dynamic>)
          .map((e) => VerseMapping.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataJuzListToJson(DataJuzList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'juz_number': instance.juzNumber,
      'verse_mapping': instance.verseMapping,
    };

VerseMapping _$VerseMappingFromJson(Map<String, dynamic> json) => VerseMapping(
      numberSurah: json['number_surah'] as int,
      verseRange: json['verse_range'] as String,
    );

Map<String, dynamic> _$VerseMappingToJson(VerseMapping instance) =>
    <String, dynamic>{
      'number_surah': instance.numberSurah,
      'verse_range': instance.verseRange,
    };
