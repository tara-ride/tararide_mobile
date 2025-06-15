// To parse this JSON data, do
//
//     final gcpDistanceMatrixModel = gcpDistanceMatrixModelFromJson(jsonString);

import 'dart:convert';

GcpDistanceMatrixModel gcpDistanceMatrixModelFromJson(String str) => GcpDistanceMatrixModel.fromJson(json.decode(str));

String gcpDistanceMatrixModelToJson(GcpDistanceMatrixModel data) => json.encode(data.toJson());

class GcpDistanceMatrixModel {
  final List<String> destinationAddresses;
  final List<String> originAddresses;
  final List<Row> rows;
  final String status;

  GcpDistanceMatrixModel({
    required this.destinationAddresses,
    required this.originAddresses,
    required this.rows,
    required this.status,
  });

  factory GcpDistanceMatrixModel.fromJson(Map<String, dynamic> json) => GcpDistanceMatrixModel(
        destinationAddresses: (json["destination_addresses"] as List<dynamic>?)?.map((x) => x as String).toList() ?? [],
        originAddresses: (json["origin_addresses"] as List<dynamic>?)?.map((x) => x as String).toList() ?? [],
        rows: (json["rows"] as List<dynamic>?)?.map((x) => Row.fromJson(x as Map<String, dynamic>)).toList() ?? [],
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "destination_addresses": destinationAddresses.map((x) => x).toList(),
        "origin_addresses": originAddresses.map((x) => x).toList(),
        "rows": rows.map((x) => x.toJson()).toList(),
        "status": status,
      };
}

class Row {
  final List<Element> elements;

  Row({
    required this.elements,
  });

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        elements: (json["elements"] as List<dynamic>?)?.map((x) => Element.fromJson(x as Map<String, dynamic>)).toList() ?? [],
      );

  Map<String, dynamic> toJson() => {
        "elements": elements.map((x) => x.toJson()).toList(),
      };
}

class Element {
  final Distance distance;
  final Distance duration;
  final Distance durationInTraffic;
  final String status;

  Element({
    required this.distance,
    required this.duration,
    required this.durationInTraffic,
    required this.status,
  });

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        distance: json["distance"] == null ? Distance(text: "", value: 0) : Distance.fromJson(json["distance"] as Map<String, dynamic>),
        duration: json["duration"] == null ? Distance(text: "", value: 0) : Distance.fromJson(json["duration"] as Map<String, dynamic>),
        durationInTraffic: json["duration_in_traffic"] == null ? Distance(text: "", value: 0) : Distance.fromJson(json["duration_in_traffic"] as Map<String, dynamic>),
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "distance": distance.toJson(),
        "duration": duration.toJson(),
        "duration_in_traffic": durationInTraffic.toJson(),
        "status": status,
      };
}

class Distance {
  final String text;
  final int value;

  Distance({
    required this.text,
    required this.value,
  });

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        text: json["text"] ?? "",
        value: json["value"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
      };
}
