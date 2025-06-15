import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/google_distance_matrix_data.dart';

abstract class GcpDistanceMatrixRepository {
  Stream<GcpDistanceMatrixModel> getDistanceMatrixData(String googleCloudAPIKey, LatLng origin, LatLng destination);
  Future<GcpDistanceMatrixModel> getDistanceMatrixDataOnce(String googleCloudAPIKey, LatLng origin, LatLng destination);
}

class GcpDistanceMatrixRepositoryImplementation extends GcpDistanceMatrixRepository {
  @override
  Stream<GcpDistanceMatrixModel> getDistanceMatrixData(String googleCloudAPIKey, LatLng origin, LatLng destination) async* {
    // https://maps.googleapis.com/maps/api/distancematrix/json?origins=ORIGIN&destinations=DESTINATION&key=YOUR_API_KEY
    final Uri url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/distancematrix/json',
      {
        'origins': '${origin.latitude},${origin.longitude}',
        'destinations': '${destination.latitude},${destination.longitude}',
        'key': googleCloudAPIKey,
      },
    );

    try {
      http.Response distanceMatrixResponse = await http.get(url);

      if (distanceMatrixResponse.statusCode >= 200 && distanceMatrixResponse.statusCode < 300) {
        GcpDistanceMatrixModel gcpDistanceMatrixModel = GcpDistanceMatrixModel.fromJson(json.decode(distanceMatrixResponse.body));

        yield gcpDistanceMatrixModel;
      } else {
        throw Exception("GCP Distance Matrix API Error: Cannot Fetch Data Properly ${distanceMatrixResponse.body}");
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<GcpDistanceMatrixModel> getDistanceMatrixDataOnce(String googleCloudAPIKey, LatLng origin, LatLng destination) async {
    final Uri url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/distancematrix/json',
      {
        'origins': '${origin.latitude},${origin.longitude}',
        'destinations': '${destination.latitude},${destination.longitude}',
        'key': googleCloudAPIKey,
      },
    );

    try {
      http.Response distanceMatrixResponse = await http.get(url);

      if (distanceMatrixResponse.statusCode >= 200 && distanceMatrixResponse.statusCode < 300) {
        GcpDistanceMatrixModel gcpDistanceMatrixModel = GcpDistanceMatrixModel.fromJson(json.decode(distanceMatrixResponse.body));
        print("GCP Distance Matrix Data: ${gcpDistanceMatrixModel.toJson()}");
        print("GCP Distance Matrix Status: ${gcpDistanceMatrixModel.status}");
        return gcpDistanceMatrixModel;
      } else {
        throw Exception("GCP Distance Matrix API Error: Cannot Fetch Data Properly ${distanceMatrixResponse.body}");
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
