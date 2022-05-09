class DetailSurahModel {
  DetailSurahModel({
    required this.code,
    required this.status,
    required this.message,
    this.data,
  });

  int code;
  String status;
  String message;
  DataDetailSurah? data;

  factory DetailSurahModel.fromJson(Map<String, dynamic> json) => DetailSurahModel(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    data: DataDetailSurah.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataDetailSurah {
  DataDetailSurah({
    required this.number,
    required this.sequence,
    required this.numberOfVerses,
    required this.name,
    required this.revelation,
    required this.tafsir,
    this.preBismillah,
    required this.verses,
  });

  int number;
  int sequence;
  int numberOfVerses;
  NameDetailSurah name;
  RevelationDetailSurah revelation;
  DataTafsirDetailSurah tafsir;
  PreBismillah? preBismillah;
  List<Verse> verses;

  factory DataDetailSurah.fromJson(Map<String, dynamic> json) => DataDetailSurah(
    number: json["number"],
    sequence: json["sequence"],
    numberOfVerses: json["numberOfVerses"],
    name: NameDetailSurah.fromJson(json["name"]),
    revelation: RevelationDetailSurah.fromJson(json["revelation"]),
    tafsir: DataTafsirDetailSurah.fromJson(json["tafsir"]),
    preBismillah: json["preBismillah"] != null ? PreBismillah.fromJson(json["preBismillah"]) : null,
    verses: List<Verse>.from(json["verses"].map((x) => Verse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "sequence": sequence,
    "numberOfVerses": numberOfVerses,
    "name": name.toJson(),
    "revelation": revelation.toJson(),
    "tafsir": tafsir.toJson(),
    "preBismillah": preBismillah!.toJson(),
    "verses": List<dynamic>.from(verses.map((x) => x.toJson())),
  };
}

class NameDetailSurah {
  NameDetailSurah({
    required this.short,
    required this.long,
    required this.transliteration,
    required this.translation,
  });

  String short;
  String long;
  TranslationDetailSurah transliteration;
  TranslationDetailSurah translation;

  factory NameDetailSurah.fromJson(Map<String, dynamic> json) => NameDetailSurah(
    short: json["short"],
    long: json["long"],
    transliteration: TranslationDetailSurah.fromJson(json["transliteration"]),
    translation: TranslationDetailSurah.fromJson(json["translation"]),
  );

  Map<String, dynamic> toJson() => {
    "short": short,
    "long": long,
    "transliteration": transliteration.toJson(),
    "translation": translation.toJson(),
  };
}

class TranslationDetailSurah {
  TranslationDetailSurah({
    required this.en,
    required this.id,
  });

  String en;
  String id;

  factory TranslationDetailSurah.fromJson(Map<String, dynamic> json) => TranslationDetailSurah(
    en: json["en"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
    "id": id,
  };
}

class PreBismillah {
  PreBismillah({
    required this.text,
    required this.translation,
    required this.audio,
  });

  TextDetailSurah text;
  TranslationDetailSurah translation;
  AudioDetailSurah audio;

  factory PreBismillah.fromJson(Map<String, dynamic> json) => PreBismillah(
    text: TextDetailSurah.fromJson(json["text"]),
    translation: TranslationDetailSurah.fromJson(json["translation"]),
    audio: AudioDetailSurah.fromJson(json["audio"]),
  );

  Map<String, dynamic> toJson() => {
    "text": text.toJson(),
    "translation": translation.toJson(),
    "audio": audio.toJson(),
  };
}

class AudioDetailSurah {
  AudioDetailSurah({
    required this.primary,
    required this.secondary,
  });

  String primary;
  List<String> secondary;

  factory AudioDetailSurah.fromJson(Map<String, dynamic> json) => AudioDetailSurah(
    primary: json["primary"],
    secondary: List<String>.from(json["secondary"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "primary": primary,
    "secondary": List<dynamic>.from(secondary.map((x) => x)),
  };
}

class TextDetailSurah {
  TextDetailSurah({
    required this.arab,
    required this.transliteration,
  });

  String arab;
  TransliterationDetailSurah transliteration;

  factory TextDetailSurah.fromJson(Map<String, dynamic> json) => TextDetailSurah(
    arab: json["arab"],
    transliteration: TransliterationDetailSurah.fromJson(json["transliteration"]),
  );

  Map<String, dynamic> toJson() => {
    "arab": arab,
    "transliteration": transliteration.toJson(),
  };
}

class TransliterationDetailSurah {
  TransliterationDetailSurah({
    required this.en,
  });

  String en;

  factory TransliterationDetailSurah.fromJson(Map<String, dynamic> json) => TransliterationDetailSurah(
    en: json["en"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
  };
}

class RevelationDetailSurah {
  RevelationDetailSurah({
    required this.arab,
    required this.en,
    required this.id,
  });

  String arab;
  String en;
  String id;

  factory RevelationDetailSurah.fromJson(Map<String, dynamic> json) => RevelationDetailSurah(
    arab: json["arab"],
    en: json["en"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "arab": arab,
    "en": en,
    "id": id,
  };
}

class DataTafsirDetailSurah {
  DataTafsirDetailSurah({
    required this.id,
  });

  String id;

  factory DataTafsirDetailSurah.fromJson(Map<String, dynamic> json) => DataTafsirDetailSurah(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}

class Verse {
  Verse({
    required this.number,
    required this.meta,
    required this.text,
    required this.translation,
    required this.audio,
    required this.tafsir,
  });

  NumberDetailSurah number;
  MetaDetailSurah meta;
  TextDetailSurah text;
  TranslationDetailSurah translation;
  AudioDetailSurah audio;
  VerseTafsirDetailSurah tafsir;

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
    number: NumberDetailSurah.fromJson(json["number"]),
    meta: MetaDetailSurah.fromJson(json["meta"]),
    text: TextDetailSurah.fromJson(json["text"]),
    translation: TranslationDetailSurah.fromJson(json["translation"]),
    audio: AudioDetailSurah.fromJson(json["audio"]),
    tafsir: VerseTafsirDetailSurah.fromJson(json["tafsir"]),
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

class MetaDetailSurah {
  MetaDetailSurah({
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
  SajdaDetailSurah sajda;

  factory MetaDetailSurah.fromJson(Map<String, dynamic> json) => MetaDetailSurah(
    juz: json["juz"],
    page: json["page"],
    manzil: json["manzil"],
    ruku: json["ruku"],
    hizbQuarter: json["hizbQuarter"],
    sajda: SajdaDetailSurah.fromJson(json["sajda"]),
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

class SajdaDetailSurah {
  SajdaDetailSurah({
    required this.recommended,
    required this.obligatory,
  });

  bool recommended;
  bool obligatory;

  factory SajdaDetailSurah.fromJson(Map<String, dynamic> json) => SajdaDetailSurah(
    recommended: json["recommended"],
    obligatory: json["obligatory"],
  );

  Map<String, dynamic> toJson() => {
    "recommended": recommended,
    "obligatory": obligatory,
  };
}

class NumberDetailSurah {
  NumberDetailSurah({
    required this.inQuran,
    required this.inSurah,
  });

  int inQuran;
  int inSurah;

  factory NumberDetailSurah.fromJson(Map<String, dynamic> json) => NumberDetailSurah(
    inQuran: json["inQuran"],
    inSurah: json["inSurah"],
  );

  Map<String, dynamic> toJson() => {
    "inQuran": inQuran,
    "inSurah": inSurah,
  };
}

class VerseTafsirDetailSurah {
  VerseTafsirDetailSurah({
    required this.id,
  });

  IdDetailSurah id;

  factory VerseTafsirDetailSurah.fromJson(Map<String, dynamic> json) => VerseTafsirDetailSurah(
    id: IdDetailSurah.fromJson(json["id"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id.toJson(),
  };
}

class IdDetailSurah {
  IdDetailSurah({
    required this.short,
    required this.long,
  });

  String short;
  String long;

  factory IdDetailSurah.fromJson(Map<String, dynamic> json) => IdDetailSurah(
    short: json["short"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "short": short,
    "long": long,
  };
}
