import 'package:json_annotation/json_annotation.dart';

part 'juz_list_model.g.dart';

@JsonSerializable()
class JuzListModel {
  List<DataJuzList> juz;

  JuzListModel({
    required this.juz,
  });

  factory JuzListModel.fromJson(Map<String, dynamic> json) => _$JuzListModelFromJson(json);

  Map<String, dynamic> toJson() => _$JuzListModelToJson(this);
}

@JsonSerializable()
class DataJuzList {
  int id;
  @JsonKey(name: 'juz_number')
  int juzNumber;
  @JsonKey(name: 'verse_mapping')
  List<VerseMapping> verseMapping;

  DataJuzList({
    required this.id,
    required this.juzNumber,
    required this.verseMapping
  });

  factory DataJuzList.fromJson(Map<String, dynamic> json) => _$DataJuzListFromJson(json);

  Map<String, dynamic> toJson() => _$DataJuzListToJson(this);
}

@JsonSerializable()
class VerseMapping {
  @JsonKey(name: 'number_surah')
  int numberSurah;
  @JsonKey(name: 'verse_range')
  String verseRange;

  VerseMapping({
    required this.numberSurah,
    required this.verseRange
  });

  factory VerseMapping.fromJson(Map<String, dynamic> json) => _$VerseMappingFromJson(json);

  Map<String, dynamic> toJson() => _$VerseMappingToJson(this);
}