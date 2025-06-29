import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';

class PassengerHistoryInteractionData {
  String historyId;
  String passengerId;
  String paymentId;
  DateTime rideCompletedAt;
  String rideDescription;
  RideCoordinates rideDestination;
  String rideId;
  RideCoordinates rideSourceLocation;

  String rideTitle;

  PassengerHistoryInteractionData({
    required this.historyId,
    required this.passengerId,
    required this.paymentId,
    required this.rideCompletedAt,
    required this.rideDescription,
    required this.rideDestination,
    required this.rideId,
    required this.rideSourceLocation,
    required this.rideTitle,
  });

  factory PassengerHistoryInteractionData.fromRawJson(String str) => PassengerHistoryInteractionData.fromJson(json.decode(str));

  factory PassengerHistoryInteractionData.fromJson(Map<String, dynamic> json) {
    GeoPoint rideSourceLocation = json["ride_source_location"] as GeoPoint;
    GeoPoint rideDestination = json["ride_destination"] as GeoPoint;

    return PassengerHistoryInteractionData(
      historyId: json["history_id"] ?? "N/A",
      passengerId: json["passenger_id"] ?? "N/A",
      paymentId: json["payment_id"] ?? "N/A",
      rideCompletedAt: DateTime.parse(json["ride_completed_at"].toDate().toString()),
      rideDescription: json["ride_description"] ?? "N/A",
      rideDestination: RideCoordinates(latitude: rideSourceLocation.latitude, longitude: rideSourceLocation.longitude),
      rideId: json["ride_id"] ?? "N/A",
      rideSourceLocation: RideCoordinates(latitude: rideDestination.latitude, longitude: rideDestination.longitude),
      rideTitle: json["ride_title"] ?? "N/A",
    );
  }
}
