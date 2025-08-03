// ignore_for_file: constant_identifier_names

import 'dart:convert';

class Places {
  String name;
  String category;
  double latitude;
  double longitude;
  City city;

  Places({
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.city,
  });

  factory Places.fromRawJson(String str) => Places.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Places.fromJson(Map<String, dynamic> json) => Places(
        name: json["name"],
        category: json["category"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        city: cityValues.map[json["city"]]!,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
        "latitude": latitude,
        "longitude": longitude,
        "city": cityValues.reverse[city],
      };
}

enum City {
  CALOOCAN_CITY,
  LAS_PINAS_CITY,
  MAKATI_CITY,
  MALABON_CITY,
  MANDALUYONG_CITY,
  MARIKINA_CITY,
  MUNTINLUPA_CITY,
  PASAY_CITY,
  PASIG_CITY,
  QUEZON_CITY,
  TAGUIG_CITY,
  VALENZUELA_CITY,
}

final cityValues = EnumValues({
  "Caloocan City": City.CALOOCAN_CITY,
  "Las Piñas City": City.LAS_PINAS_CITY,
  "Makati City": City.MAKATI_CITY,
  "Malabon City": City.MALABON_CITY,
  "Mandaluyong City": City.MANDALUYONG_CITY,
  "Marikina City": City.MARIKINA_CITY,
  "Muntinlupa City": City.MUNTINLUPA_CITY,
  "Pasay City": City.PASAY_CITY,
  "Pasig City": City.PASIG_CITY,
  "Quezon City": City.QUEZON_CITY,
  "Taguig City": City.TAGUIG_CITY,
  "Valenzuela City": City.VALENZUELA_CITY
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
