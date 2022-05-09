// To parse this JSON data, do
//
//     final juzModel = juzModelFromJson(jsonString);

import 'dart:convert';

JuzModel juzModelFromJson(String str) => JuzModel.fromJson(json.decode(str));

String juzModelToJson(JuzModel data) => json.encode(data.toJson());

class JuzModel {
  JuzModel({
    required this.code,
    required this.status,
    required this.message,
    this.data,
  });

  int code;
  String status;
  String message;
  DataJuz? data;

  factory JuzModel.fromJson(Map<String, dynamic> json) => JuzModel(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    data: DataJuz.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataJuz {
  DataJuz({
    required this.juz,
    required this.start,
    required this.end,
    required this.verses,
  });

  int juz;
  String start;
  String end;
  List<VerseJuz> verses;

  factory DataJuz.fromJson(Map<String, dynamic> json) => DataJuz(
    juz: json["juz"],
    start: json["start"],
    end: json["end"],
    verses: List<VerseJuz>.from(json["verses"].map((x) => VerseJuz.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "juz": juz,
    "start": start,
    "end": end,
    "verses": List<dynamic>.from(verses.map((x) => x.toJson())),
  };
}

class VerseJuz {
  VerseJuz({
    required this.number,
    required this.meta,
    required this.text,
    required this.translation,
    required this.audio,
    required this.tafsir,
  });

  NumberJuz number;
  MetaJuz meta;
  TextJuz text;
  TranslationJuz translation;
  AudioJuz audio;
  TafsirJuz tafsir;

  factory VerseJuz.fromJson(Map<String, dynamic> json) => VerseJuz(
    number: NumberJuz.fromJson(json["number"]),
    meta: MetaJuz.fromJson(json["meta"]),
    text: TextJuz.fromJson(json["text"]),
    translation: TranslationJuz.fromJson(json["translation"]),
    audio: AudioJuz.fromJson(json["audio"]),
    tafsir: TafsirJuz.fromJson(json["tafsir"]),
  );

  Map<String, dynamic> toJson() => {
    "number": number.toJson(),
    "meta": meta.toJson(),
    "text": text.toJson(),
    "translation": translation.toJson(),
    "audio": audio.toJson(),
    "tafsir": tafsir.toJson(),
  };
}

class AudioJuz {
  AudioJuz({
    required this.primary,
    required this.secondary,
  });

  String primary;
  List<String> secondary;

  factory AudioJuz.fromJson(Map<String, dynamic> json) => AudioJuz(
    primary: json["primary"],
    secondary: List<String>.from(json["secondary"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "primary": primary,
    "secondary": List<dynamic>.from(secondary.map((x) => x)),
  };
}

class MetaJuz {
  MetaJuz({
    required this.juz,
    required this.page,
    required this.manzil,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  int juz;
  int page;
  int manzil;
  int ruku;
  int hizbQuarter;
  SajdaJuz sajda;

  factory MetaJuz.fromJson(Map<String, dynamic> json) => MetaJuz(
    juz: json["juz"],
    page: json["page"],
    manzil: json["manzil"],
    ruku: json["ruku"],
    hizbQuarter: json["hizbQuarter"],
    sajda: SajdaJuz.fromJson(json["sajda"]),
  );

  Map<String, dynamic> toJson() => {
    "juz": juz,
    "page": page,
    "manzil": manzil,
    "ruku": ruku,
    "hizbQuarter": hizbQuarter,
    "sajda": sajda.toJson(),
  };
}

class SajdaJuz {
  SajdaJuz({
    required this.recommended,
    required this.obligatory,
  });

  bool recommended;
  bool obligatory;

  factory SajdaJuz.fromJson(Map<String, dynamic> json) => SajdaJuz(
    recommended: json["recommended"],
    obligatory: json["obligatory"],
  );

  Map<String, dynamic> toJson() => {
    "recommended": recommended,
    "obligatory": obligatory,
  };
}

class NumberJuz {
  NumberJuz({
    required this.inQuran,
    required this.inSurah,
  });

  int inQuran;
  int inSurah;

  factory NumberJuz.fromJson(Map<String, dynamic> json) => NumberJuz(
    inQuran: json["inQuran"],
    inSurah: json["inSurah"],
  );

  Map<String, dynamic> toJson() => {
    "inQuran": inQuran,
    "inSurah": inSurah,
  };
}

class TafsirJuz {
  TafsirJuz({
    required this.id,
  });

  IdJuz id;

  factory TafsirJuz.fromJson(Map<String, dynamic> json) => TafsirJuz(
    id: IdJuz.fromJson(json["id"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id.toJson(),
  };
}

class IdJuz {
  IdJuz({
    required this.short,
    required this.long,
  });

  String short;
  String long;

  factory IdJuz.fromJson(Map<String, dynamic> json) => IdJuz(
    short: json["short"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "short": short,
    "long": long,
  };
}

class TextJuz {
  TextJuz({
    required this.arab,
    required this.transliteration,
  });

  String arab;
  TransliterationJuz transliteration;

  factory TextJuz.fromJson(Map<String, dynamic> json) => TextJuz(
    arab: json["arab"],
    transliteration: TransliterationJuz.fromJson(json["transliteration"]),
  );

  Map<String, dynamic> toJson() => {
    "arab": arab,
    "transliteration": transliteration.toJson(),
  };
}

class TransliterationJuz {
  TransliterationJuz({
    required this.en,
  });

  String en;

  factory TransliterationJuz.fromJson(Map<String, dynamic> json) => TransliterationJuz(
    en: json["en"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
  };
}

class TranslationJuz {
  TranslationJuz({
    required this.en,
    required this.id,
  });

  String en;
  String id;

  factory TranslationJuz.fromJson(Map<String, dynamic> json) => TranslationJuz(
    en: json["en"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
    "id": id,
  };
}
