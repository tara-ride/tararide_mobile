import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class RideInformationModel {
  String rideId;
  String driverName;
  String driverId;
  String driverEmail;
  String rideTitle;
  String rideDescription;
  RideCoordinates rideSourceLocation;
  RideCoordinates rideDestination;
  RideCoordinates driverCurrentLocation;

  double rideCost;
  double rideEarnings;
  int seatsAllocated;
  List<PassengersList> passengersList;
  int availableSeats;
  String status;
  String carType;
  String rideType;

  RideInformationModel({
    required this.driverName,
    required this.driverId,
    required this.driverEmail,
    required this.rideTitle,
    required this.rideDescription,
    required this.rideSourceLocation,
    required this.rideDestination,
    required this.seatsAllocated,
    required this.passengersList,
    required this.availableSeats,
    required this.rideCost,
    required this.driverCurrentLocation,
    required this.status,
    required this.carType,
    required this.rideEarnings,
    required this.rideType,
    required this.rideId,
  });

  factory RideInformationModel.fromRawJson(String str) => RideInformationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RideInformationModel.fromJson(Map<String, dynamic> json) {
    GeoPoint geoPointSourceLocation = GeoPoint(json["ride_source_location"].latitude ?? 0, json["ride_source_location"].longitude ?? 0);
    GeoPoint geoPointDestination = GeoPoint(json["ride_destination"].latitude ?? 0, json["ride_destination"].longitude ?? 0);
    GeoPoint getPointDriverCurrentLocation = GeoPoint(json["driver_current_location"].latitude ?? 0, json["ride_destination"].longitude ?? 0);
    if (json.isEmpty) {
      return RideInformationModel(
        rideId: '',
        rideEarnings: 0,
        rideCost: 0,
        driverName: '',
        driverId: '',
        driverEmail: '',
        rideTitle: '',
        rideDescription: '',
        rideSourceLocation: RideCoordinates(latitude: 0.0, longitude: 0.0),
        rideDestination: RideCoordinates(latitude: 0.0, longitude: 0.0),
        seatsAllocated: 1,
        passengersList: [],
        availableSeats: 0,
        status: 'inactive',
        carType: 'sedan',
        rideType: 'regular',
        driverCurrentLocation: RideCoordinates(latitude: 0.0, longitude: 0.0),
      );
    }
    return RideInformationModel(
      rideId: json["ride_id"] ?? '',
      driverName: json["driver_name"] ?? '',
      driverId: json["driver_id"] ?? '',
      driverEmail: json["driver_email"] ?? '',
      rideTitle: json["ride_title"] ?? '',
      rideDescription: json["ride_description"] ?? '',
      rideSourceLocation: RideCoordinates(latitude: geoPointSourceLocation.latitude, longitude: geoPointSourceLocation.longitude),
      rideDestination: RideCoordinates(latitude: geoPointDestination.latitude, longitude: geoPointDestination.longitude),
      seatsAllocated: json["seats_allocated"] ?? 1,
      passengersList: List<PassengersList>.from(json["passengers_list"].map((x) => PassengersList.fromJson(x)) ?? []),
      availableSeats: json["available_seats"] ?? 0,
      status: json["status"] ?? 'inactive',
      carType: json["car_type"] ?? 'sedan',
      rideType: json["ride_type"] ?? 'regular',
      rideEarnings: double.parse("${json["ride_earnings"]}"),
      rideCost: double.parse("${json["ride_cost"]}"),
      driverCurrentLocation: RideCoordinates(latitude: getPointDriverCurrentLocation.latitude, longitude: getPointDriverCurrentLocation.longitude),
    );
  }

  Map<String, dynamic> toJson() => {
        "driver_name": driverName,
        "driver_id": driverId,
        "driver_email": driverEmail,
        "ride_source_location": rideSourceLocation.toJson(),
        "ride_destination": rideDestination.toJson(),
        "seats_allocated": seatsAllocated,
        "passengers_list": List<dynamic>.from(passengersList.map((x) => x.toJson())),
        "available_seats": availableSeats,
        "status": status,
        "car_type": carType,
        "ride_type": rideType,
      };
}

class PassengersList {
  RideCoordinates passengerSourceLocation;
  String passengerId;
  RideCoordinates passengerCurrentLocation;
  double estimatedFare;
  RideCoordinates passengerDestination;
  String passengerName;
  String passengerEmail;
  String passengerDestinationName;
  String passengerSourceLocationName;
  double rideDistance;
  String rideDuration;
  int seatsOccupied;
  DateTime rideCompletedAt;
  DateTime rideStartedAt;

  PassengersList(
      {required this.passengerSourceLocation,
      required this.rideDistance,
      required this.passengerId,
      required this.passengerCurrentLocation,
      required this.estimatedFare,
      required this.passengerDestination,
      required this.passengerName,
      required this.passengerDestinationName,
      required this.passengerEmail,
      required this.passengerSourceLocationName,
      required this.rideDuration,
      required this.seatsOccupied,
      required this.rideCompletedAt,
      required this.rideStartedAt});

  factory PassengersList.fromRawJson(String str) => PassengersList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PassengersList.fromJson(Map<String, dynamic> json) {
    GeoPoint passengerSourceLocation = json["passenger_source_location"] as GeoPoint;
    GeoPoint passengerDestination = json["passenger_destination"] as GeoPoint;
    if (json.isEmpty) {
      return PassengersList(
        rideDistance: 0,
        passengerCurrentLocation: RideCoordinates(latitude: 0.0, longitude: 0.0),
        passengerSourceLocation: RideCoordinates(latitude: 0.0, longitude: 0.0),
        passengerId: 'N/A',
        estimatedFare: 0.0,
        passengerDestination: RideCoordinates(latitude: 0.0, longitude: 0.0),
        passengerName: 'Unknown',
        passengerDestinationName: '',
        passengerEmail: '',
        passengerSourceLocationName: '',
        rideDuration: '',
        seatsOccupied: 0,
        rideCompletedAt: DateTime.now(),
        rideStartedAt: DateTime.now(),
      );
    }

    return PassengersList(
      rideDistance: json["estimated_fare"].toDouble() ?? 0.0,
      passengerSourceLocation: RideCoordinates(latitude: passengerSourceLocation.latitude, longitude: passengerSourceLocation.longitude),
      passengerId: json["passenger_id"] ?? 'N/A',
      estimatedFare: json["estimated_fare"].toDouble() ?? 0.0,
      passengerDestination: RideCoordinates(latitude: passengerDestination.latitude, longitude: passengerDestination.longitude),
      passengerName: json["passenger_name"] ?? 'Unknown',
      passengerDestinationName: json["passenger_destination_name"] ?? 'N/A',
      passengerEmail: json["passenger_email"] ?? 'N/A',
      passengerSourceLocationName: json["passenger_source_location_name"] ?? 'N/A',
      rideDuration: json["ride_duration"] ?? 'N/A',
      seatsOccupied: int.parse(json["seats_occupied"].toString()),
      rideCompletedAt: DateTime.parse(json["ride_completed_at"].toDate().toString()),
      rideStartedAt: DateTime.parse(json["ride_started_at"].toDate().toString()),
      passengerCurrentLocation: RideCoordinates(latitude: passengerDestination.latitude, longitude: passengerDestination.longitude),
    );
  }

  Map<String, dynamic> toJson() => {
        "passenger_source_location": passengerSourceLocation.toJson(),
        "passenger_id": passengerId,
        "estimated_fare": estimatedFare,
        "passenger_destination": passengerDestination.toJson(),
        "passenger_name": passengerName,
      };
}

class RideCoordinates {
  double latitude;
  double longitude;

  RideCoordinates({
    required this.latitude,
    required this.longitude,
  });

  factory RideCoordinates.fromRawJson(String str) => RideCoordinates.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RideCoordinates.fromJson(Map<String, dynamic> json) => RideCoordinates(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
