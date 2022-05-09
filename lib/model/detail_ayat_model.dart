class DetailAyatModel {
  DetailAyatModel({
    required this.code,
    required this.status,
    required this.message,
    this.data,
  });

  int code;
  String status;
  String message;
  DataDetailAyat? data;

  factory DetailAyatModel.fromJson(Map<String, dynamic> json) => DetailAyatModel(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    data: json["data"] != null ? DataDetailAyat.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataDetailAyat {
  DataDetailAyat({
    required this.number,
    required this.meta,
    required this.text,
    required this.translation,
    required this.audio,
    required this.tafsir,
    required this.surah,
  });

  NumberDetailAyat number;
  MetaDetailAyat meta;
  TextDetailAyat text;
  TranslationDetailAyat translation;
  AudioDetailAyat audio;
  DataTafsirDetailAyat tafsir;
  SurahDetailAyat surah;

  factory DataDetailAyat.fromJson(Map<String, dynamic> json) => DataDetailAyat(
    number: NumberDetailAyat.fromJson(json["number"]),
    meta: MetaDetailAyat.fromJson(json["meta"]),
    text: TextDetailAyat.fromJson(json["text"]),
    translation: TranslationDetailAyat.fromJson(json["translation"]),
    audio: AudioDetailAyat.fromJson(json["audio"]),
    tafsir: DataTafsirDetailAyat.fromJson(json["tafsir"]),
    surah: SurahDetailAyat.fromJson(json["surah"]),
  );

  Map<String, dynamic> toJson() => {
    "number": number.toJson(),
    "meta": meta.toJson(),
    "text": text.toJson(),
    "translation": translation.toJson(),
    "audio": audio.toJson(),
    "tafsir": tafsir.toJson(),
    "surah": surah.toJson(),
  };
}

class AudioDetailAyat {
  AudioDetailAyat({
    required this.primary,
    required this.secondary,
  });

  String primary;
  List<String> secondary;

  factory AudioDetailAyat.fromJson(Map<String, dynamic> json) => AudioDetailAyat(
    primary: json["primary"],
    secondary: List<String>.from(json["secondary"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "primary": primary,
    "secondary": List<dynamic>.from(secondary.map((x) => x)),
  };
}

class MetaDetailAyat {
  MetaDetailAyat({
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
  SajdaDetailAyat sajda;

  factory MetaDetailAyat.fromJson(Map<String, dynamic> json) => MetaDetailAyat(
    juz: json["juz"],
    page: json["page"],
    manzil: json["manzil"],
    ruku: json["ruku"],
    hizbQuarter: json["hizbQuarter"],
    sajda: SajdaDetailAyat.fromJson(json["sajda"]),
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

class SajdaDetailAyat {
  SajdaDetailAyat({
    required this.recommended,
    required this.obligatory,
  });

  bool recommended;
  bool obligatory;

  factory SajdaDetailAyat.fromJson(Map<String, dynamic> json) => SajdaDetailAyat(
    recommended: json["recommended"],
    obligatory: json["obligatory"],
  );

  Map<String, dynamic> toJson() => {
    "recommended": recommended,
    "obligatory": obligatory,
  };
}

class NumberDetailAyat {
  NumberDetailAyat({
    required this.inQuran,
    required this.inSurah,
  });

  int inQuran;
  int inSurah;

  factory NumberDetailAyat.fromJson(Map<String, dynamic> json) => NumberDetailAyat(
    inQuran: json["inQuran"],
    inSurah: json["inSurah"],
  );

  Map<String, dynamic> toJson() => {
    "inQuran": inQuran,
    "inSurah": inSurah,
  };
}

class SurahDetailAyat {
  SurahDetailAyat({
    required this.number,
    required this.sequence,
    required this.numberOfVerses,
    required this.name,
    required this.revelation,
    required this.tafsir,
    this.preBismillah,
  });

  int number;
  int sequence;
  int numberOfVerses;
  NameDetailAyat name;
  RevelationDetailAyat revelation;
  SurahTafsirDetailAyat tafsir;
  PreBismillahDetailAyat? preBismillah;

  factory SurahDetailAyat.fromJson(Map<String, dynamic> json) => SurahDetailAyat(
    number: json["number"],
    sequence: json["sequence"],
    numberOfVerses: json["numberOfVerses"],
    name: NameDetailAyat.fromJson(json["name"]),
    revelation: RevelationDetailAyat.fromJson(json["revelation"]),
    tafsir: SurahTafsirDetailAyat.fromJson(json["tafsir"]),
    preBismillah: json["preBismillah"] != null ? PreBismillahDetailAyat.fromJson(json["preBismillah"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "sequence": sequence,
    "numberOfVerses": numberOfVerses,
    "name": name.toJson(),
    "revelation": revelation.toJson(),
    "tafsir": tafsir.toJson(),
    "preBismillah": preBismillah?.toJson(),
  };
}

class NameDetailAyat {
  NameDetailAyat({
    required this.short,
    required this.long,
    required this.transliteration,
    required this.translation,
  });

  String short;
  String long;
  TransliterationDetailAyat transliteration;
  TranslationDetailAyat translation;

  factory NameDetailAyat.fromJson(Map<String, dynamic> json) => NameDetailAyat(
    short: json["short"],
    long: json["long"],
    transliteration: TransliterationDetailAyat.fromJson(json["transliteration"]),
    translation: TranslationDetailAyat.fromJson(json["translation"]),
  );

  Map<String, dynamic> toJson() => {
    "short": short,
    "long": long,
    "transliteration": transliteration.toJson(),
    "translation": translation.toJson(),
  };
}

class TranslationDetailAyat {
  TranslationDetailAyat({
    required this.en,
    required this.id,
  });

  String en;
  String id;

  factory TranslationDetailAyat.fromJson(Map<String, dynamic> json) => TranslationDetailAyat(
    en: json["en"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
    "id": id,
  };
}

class PreBismillahDetailAyat {
  PreBismillahDetailAyat({
    required this.text,
    required this.translation,
    required this.audio,
  });

  TextDetailAyat text;
  TranslationDetailAyat translation;
  AudioDetailAyat audio;

  factory PreBismillahDetailAyat.fromJson(Map<String, dynamic> json) => PreBismillahDetailAyat(
    text: TextDetailAyat.fromJson(json["text"]),
    translation: TranslationDetailAyat.fromJson(json["translation"]),
    audio: AudioDetailAyat.fromJson(json["audio"]),
  );

  Map<String, dynamic> toJson() => {
    "text": text.toJson(),
    "translation": translation.toJson(),
    "audio": audio.toJson(),
  };
}

class TextDetailAyat {
  TextDetailAyat({
    required this.arab,
    required this.transliteration,
  });

  String arab;
  TransliterationDetailAyat transliteration;

  factory TextDetailAyat.fromJson(Map<String, dynamic> json) => TextDetailAyat(
    arab: json["arab"],
    transliteration: TransliterationDetailAyat.fromJson(json["transliteration"]),
  );

  Map<String, dynamic> toJson() => {
    "arab": arab,
    "transliteration": transliteration.toJson(),
  };
}

class TransliterationDetailAyat {
  TransliterationDetailAyat({
    required this.en,
    this.id
  });

  String en;
  String? id;

  factory TransliterationDetailAyat.fromJson(Map<String, dynamic> json) => TransliterationDetailAyat(
    en: json["en"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
  };
}

class RevelationDetailAyat {
  RevelationDetailAyat({
    required this.arab,
    required this.en,
    required this.id,
  });

  String arab;
  String en;
  String id;

  factory RevelationDetailAyat.fromJson(Map<String, dynamic> json) => RevelationDetailAyat(
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

class SurahTafsirDetailAyat {
  SurahTafsirDetailAyat({
    required this.id,
  });

  String id;

  factory SurahTafsirDetailAyat.fromJson(Map<String, dynamic> json) => SurahTafsirDetailAyat(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}

class DataTafsirDetailAyat {
  DataTafsirDetailAyat({
    required this.id,
  });

  IdDetailAyat id;

  factory DataTafsirDetailAyat.fromJson(Map<String, dynamic> json) => DataTafsirDetailAyat(
    id: IdDetailAyat.fromJson(json["id"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id.toJson(),
  };
}

class IdDetailAyat {
  IdDetailAyat({
    required this.short,
    required this.long,
  });

  String short;
  String long;

  factory IdDetailAyat.fromJson(Map<String, dynamic> json) => IdDetailAyat(
    short: json["short"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "short": short,
    "long": long,
  };
}