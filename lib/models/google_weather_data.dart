import 'package:meta/meta.dart';
import 'dart:convert';

class GoogleWeatherData {
  DateTime currentTime;
  TimeZone timeZone;
  bool isDaytime;
  WeatherCondition weatherCondition;
  DewPoint temperature;
  DewPoint feelsLikeTemperature;
  DewPoint dewPoint;
  DewPoint heatIndex;
  DewPoint windChill;
  double relativeHumidity;
  double uvIndex;
  Precipitation precipitation;
  double thunderstormProbability;
  AirPressure airPressure;
  Wind wind;
  Visibility visibility;
  double cloudCover;
  CurrentConditionsHistory currentConditionsHistory;

  GoogleWeatherData({
    required this.currentTime,
    required this.timeZone,
    required this.isDaytime,
    required this.weatherCondition,
    required this.temperature,
    required this.feelsLikeTemperature,
    required this.dewPoint,
    required this.heatIndex,
    required this.windChill,
    required this.relativeHumidity,
    required this.uvIndex,
    required this.precipitation,
    required this.thunderstormProbability,
    required this.airPressure,
    required this.wind,
    required this.visibility,
    required this.cloudCover,
    required this.currentConditionsHistory,
  });

  factory GoogleWeatherData.fromRawJson(String str) => GoogleWeatherData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GoogleWeatherData.fromJson(Map<String, dynamic> json) => GoogleWeatherData(
        currentTime: DateTime.parse(json["currentTime"]),
        timeZone: TimeZone.fromJson(json["timeZone"]),
        isDaytime: json["isDaytime"],
        weatherCondition: WeatherCondition.fromJson(json["weatherCondition"]),
        temperature: DewPoint.fromJson(json["temperature"]),
        feelsLikeTemperature: DewPoint.fromJson(json["feelsLikeTemperature"]),
        dewPoint: DewPoint.fromJson(json["dewPoint"]),
        heatIndex: DewPoint.fromJson(json["heatIndex"]),
        windChill: DewPoint.fromJson(json["windChill"]),
        relativeHumidity: double.tryParse(json["relativeHumidity"].toString()) ?? 0.0,
        uvIndex: double.tryParse(json["uvIndex"].toString()) ?? 0.0,
        precipitation: Precipitation.fromJson(json["precipitation"]),
        thunderstormProbability: double.tryParse(json["thunderstormProbability"].toString()) ?? 0.0,
        airPressure: AirPressure.fromJson(json["airPressure"]),
        wind: Wind.fromJson(json["wind"]),
        visibility: Visibility.fromJson(json["visibility"]),
        cloudCover: double.tryParse(json["cloudCover"].toString()) ?? 0.0,
        currentConditionsHistory: CurrentConditionsHistory.fromJson(json["currentConditionsHistory"]),
      );

  Map<String, dynamic> toJson() => {
        "currentTime": currentTime.toIso8601String(),
        "timeZone": timeZone.toJson(),
        "isDaytime": isDaytime,
        "weatherCondition": weatherCondition.toJson(),
        "temperature": temperature.toJson(),
        "feelsLikeTemperature": feelsLikeTemperature.toJson(),
        "dewPoint": dewPoint.toJson(),
        "heatIndex": heatIndex.toJson(),
        "windChill": windChill.toJson(),
        "relativeHumidity": relativeHumidity,
        "uvIndex": uvIndex,
        "precipitation": precipitation.toJson(),
        "thunderstormProbability": thunderstormProbability,
        "airPressure": airPressure.toJson(),
        "wind": wind.toJson(),
        "visibility": visibility.toJson(),
        "cloudCover": cloudCover,
        "currentConditionsHistory": currentConditionsHistory.toJson(),
      };
}

class AirPressure {
  double meanSeaLevelMillibars;

  AirPressure({
    required this.meanSeaLevelMillibars,
  });

  factory AirPressure.fromRawJson(String str) => AirPressure.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AirPressure.fromJson(Map<String, dynamic> json) => AirPressure(
        meanSeaLevelMillibars: json["meanSeaLevelMillibars"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "meanSeaLevelMillibars": meanSeaLevelMillibars,
      };
}

class CurrentConditionsHistory {
  DewPoint temperatureChange;
  DewPoint maxTemperature;
  DewPoint minTemperature;
  Qpf qpf;

  CurrentConditionsHistory({
    required this.temperatureChange,
    required this.maxTemperature,
    required this.minTemperature,
    required this.qpf,
  });

  factory CurrentConditionsHistory.fromRawJson(String str) => CurrentConditionsHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrentConditionsHistory.fromJson(Map<String, dynamic> json) => CurrentConditionsHistory(
        temperatureChange: DewPoint.fromJson(json["temperatureChange"]),
        maxTemperature: DewPoint.fromJson(json["maxTemperature"]),
        minTemperature: DewPoint.fromJson(json["minTemperature"]),
        qpf: Qpf.fromJson(json["qpf"]),
      );

  Map<String, dynamic> toJson() => {
        "temperatureChange": temperatureChange.toJson(),
        "maxTemperature": maxTemperature.toJson(),
        "minTemperature": minTemperature.toJson(),
        "qpf": qpf.toJson(),
      };
}

class DewPoint {
  double degrees;
  String unit;

  DewPoint({
    required this.degrees,
    required this.unit,
  });

  factory DewPoint.fromRawJson(String str) => DewPoint.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DewPoint.fromJson(Map<String, dynamic> json) => DewPoint(
        degrees: json["degrees"]?.toDouble(),
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "degrees": degrees,
        "unit": unit,
      };
}

class Qpf {
  int quantity;
  String unit;

  Qpf({
    required this.quantity,
    required this.unit,
  });

  factory Qpf.fromRawJson(String str) => Qpf.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Qpf.fromJson(Map<String, dynamic> json) => Qpf(
        quantity: int.tryParse(json["quantity"].toString()) ?? 0,
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "unit": unit,
      };
}

class Precipitation {
  Probability probability;
  Qpf qpf;

  Precipitation({
    required this.probability,
    required this.qpf,
  });

  factory Precipitation.fromRawJson(String str) => Precipitation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Precipitation.fromJson(Map<String, dynamic> json) => Precipitation(
        probability: Probability.fromJson(json["probability"]),
        qpf: Qpf.fromJson(json["qpf"]),
      );

  Map<String, dynamic> toJson() => {
        "probability": probability.toJson(),
        "qpf": qpf.toJson(),
      };
}

class Probability {
  double percent;
  String type;

  Probability({
    required this.percent,
    required this.type,
  });

  factory Probability.fromRawJson(String str) => Probability.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Probability.fromJson(Map<String, dynamic> json) => Probability(
        percent: double.tryParse(json["percent"].toString()) ?? 0.0,
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "percent": percent,
        "type": type,
      };
}

class TimeZone {
  String id;

  TimeZone({
    required this.id,
  });

  factory TimeZone.fromRawJson(String str) => TimeZone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TimeZone.fromJson(Map<String, dynamic> json) => TimeZone(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class Visibility {
  double distance;
  String unit;

  Visibility({
    required this.distance,
    required this.unit,
  });

  factory Visibility.fromRawJson(String str) => Visibility.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Visibility.fromJson(Map<String, dynamic> json) => Visibility(
        distance: double.tryParse(json["distance"].toString()) ?? 0.0,
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "unit": unit,
      };
}

class WeatherCondition {
  String iconBaseUri;
  Description description;
  String type;

  WeatherCondition({
    required this.iconBaseUri,
    required this.description,
    required this.type,
  });

  factory WeatherCondition.fromRawJson(String str) => WeatherCondition.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeatherCondition.fromJson(Map<String, dynamic> json) => WeatherCondition(
        iconBaseUri: json["iconBaseUri"],
        description: Description.fromJson(json["description"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "iconBaseUri": iconBaseUri,
        "description": description.toJson(),
        "type": type,
      };
}

class Description {
  String text;
  String languageCode;

  Description({
    required this.text,
    required this.languageCode,
  });

  factory Description.fromRawJson(String str) => Description.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        text: json["text"],
        languageCode: json["languageCode"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "languageCode": languageCode,
      };
}

class Wind {
  Direction direction;
  Gust speed;
  Gust gust;

  Wind({
    required this.direction,
    required this.speed,
    required this.gust,
  });

  factory Wind.fromRawJson(String str) => Wind.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        direction: Direction.fromJson(json["direction"]),
        speed: Gust.fromJson(json["speed"]),
        gust: Gust.fromJson(json["gust"]),
      );

  Map<String, dynamic> toJson() => {
        "direction": direction.toJson(),
        "speed": speed.toJson(),
        "gust": gust.toJson(),
      };
}

class Direction {
  double degrees;
  String cardinal;

  Direction({
    required this.degrees,
    required this.cardinal,
  });

  factory Direction.fromRawJson(String str) => Direction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Direction.fromJson(Map<String, dynamic> json) => Direction(
        degrees: double.tryParse(json["degrees"].toString()) ?? 0.0,
        cardinal: json["cardinal"],
      );

  Map<String, dynamic> toJson() => {
        "degrees": degrees,
        "cardinal": cardinal,
      };
}

class Gust {
  int value;
  String unit;

  Gust({
    required this.value,
    required this.unit,
  });

  factory Gust.fromRawJson(String str) => Gust.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Gust.fromJson(Map<String, dynamic> json) => Gust(
        value: int.tryParse(json["value"].toString()) ?? 0,
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "unit": unit,
      };
}
