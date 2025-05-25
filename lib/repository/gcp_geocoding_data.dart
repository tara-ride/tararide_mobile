import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tararide_mobile/config/firebase_options.dart';

import '../models/geocoding_data.dart';

abstract class GCPGeocodingDataRepository {
  Stream<String> getGeocodingData(String address);
}

class GcpGeocodingDataRepositoryImplementation extends GCPGeocodingDataRepository {
  @override
  Stream<String> getGeocodingData(String address) async* {
    //https://maps.googleapis.com/maps/api/geocode/json?address=ADDRESS&key=YOUR_API_KEY
    //https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=YOUR_API_KEY
    address = address.replaceAll(" ", "+");

    final Uri url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'address': address,
        'key': SystemConstants().getGoogleCloudAPIKey,
      },
    );

    try {
      http.Response geocodingDataResponse = await http.get(url);

      if (geocodingDataResponse.statusCode >= 200 && geocodingDataResponse.statusCode < 300) {
        var googleGeocodingDataJson = json.decode(geocodingDataResponse.body);

        String googleGeocodingData = googleGeocodingDataJson.toString();

        await Future.delayed(const Duration(seconds: 5));
        yield googleGeocodingData;
      } else {
        throw Exception("GCP Geocoding API Error: Cannot Fetch Data Properly ${geocodingDataResponse.body}");
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<GeocodingData> getGeocodingDataFromAddress(String address) async {
    //https://maps.googleapis.com/maps/api/geocode/json?address
    address = address.replaceAll(" ", "%");
    final Uri url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'address': address,
        'key': SystemConstants().getGoogleCloudAPIKey,
      },
    );

    try {
      print("Step 1");
      http.Response geocodingDataResponse = await http.get(url);
      print("Step 2");
      if (geocodingDataResponse.statusCode >= 200 && geocodingDataResponse.statusCode < 300) {
        print("Step 3");
        var googleGeocodingDataJson = json.decode(geocodingDataResponse.body);
        print("Step 4 ${googleGeocodingDataJson}"); 
        GeocodingData geocodingData = GeocodingData.fromJson(googleGeocodingDataJson);
        print("Step 5 ${geocodingData.results.length}");
        print("Step 6 ${geocodingData.results[0].formattedAddress}");
        return geocodingData;
      } else {
        throw Exception("GCP Geocoding API Error: Cannot Fetch Data Properly ${geocodingDataResponse.body}");
      }
    } catch (error) {
      print("Error:  NAG ERROR BAAA :< $error");
      throw Exception(error);
    }
  }
}
