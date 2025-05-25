import 'dart:convert';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tararide_mobile/models/google_weather_data.dart';
import 'package:http/http.dart' as http;

abstract class GCPWeatherApiRepository {
  Stream<GoogleWeatherData> getWeatherData(String googleCloudAPIKey, LatLng coordinates);
}

class GcpWeatherApiRepositoryImplementation extends GCPWeatherApiRepository {
  @override
  Stream<GoogleWeatherData> getWeatherData(String googleCloudAPIKey, LatLng coordinates) async* {
    //https://weather.googleapis.com/v1/currentConditions:lookup?key=YOUR_API_KEY&location.latitude=LATITUDE&location.longitude=LONGITUDE
    final Uri url = Uri.https(
      'weather.googleapis.com',
      '/v1/currentConditions:lookup',
      {
        'key': googleCloudAPIKey,
        'location.latitude': "14.410691",
        'location.longitude': "121.038055",
      },
    );
//14.410691, 121.038055
//  'location.latitude': coordinates.latitude.toString(),
//         'location.longitude': coordinates.longitude.toString(),
    try {
      http.Response weatherDataResponse = await http.get(url);

      if (weatherDataResponse.statusCode >= 200 && weatherDataResponse.statusCode < 300) {
        var googleWeatherDataJson = json.decode(weatherDataResponse.body);

        GoogleWeatherData googleWeatherData = GoogleWeatherData.fromJson(googleWeatherDataJson);

        yield googleWeatherData;
      } else {
        throw Exception("GCP Weather API Error: Cannot Fetch Data Properly ${weatherDataResponse.body}");
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
