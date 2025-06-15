import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tararide_mobile/models/google_weather_data.dart';

import 'package:tararide_mobile/models/geocoding_data.dart' as GeocodingDataModel;
import 'package:tararide_mobile/models/ride_information_data.dart';
import 'package:tararide_mobile/repository/driver_ride_information_repository.dart';
import 'package:tararide_mobile/views/driver/driver_ride_page/component_widgets/driver_load_weather_data.dart';

import '../../config/firebase_options.dart';
import '../../models/google_distance_matrix_data.dart';
import '../../repository/gcp_distance_matrix_repository.dart';
import '../../repository/gcp_geocoding_data.dart';
import '../../repository/gcp_weather_api_repository.dart';
import '../../repository/passenger_ride_information_repository.dart';

part 'driver_ride_status_event.dart';
part 'driver_ride_status_state.dart';

class DriverRideStatusBloc extends Bloc<DriverRideStatusEvent, DriverRideStatusState> {
  GcpWeatherApiRepositoryImplementation _gcpWeatherApiRepositoryImplementation = GcpWeatherApiRepositoryImplementation();
  GcpGeocodingDataRepositoryImplementation _gcpGeocodingDataRepositoryImplementation = GcpGeocodingDataRepositoryImplementation();
  DriverRideInformationRepositoryImplementation _driverRideInformationRepositoryImplementation = DriverRideInformationRepositoryImplementation();
  StreamSubscription? _streamSubscription;
  StreamSubscription? _gcpGeocodingDataStreamSubscription;
  List<GeocodingDataModel.Result> possibleStartLocations = [];
  List<GeocodingDataModel.Result> possibleDestinationList = [];

  DriverRideStatusBloc() : super(const DriverRideStatusInitial()) {
    on<DriverRideInitialize>((event, emit) {
      emit(const DriverRideStatusInitial());
    });

    on<DriverRideStatusLoadWeatherData>((event, emit) async {
      if (_streamSubscription != null) {
        await _streamSubscription!.cancel();
      }
      if (_gcpGeocodingDataStreamSubscription != null) {
        await _gcpGeocodingDataStreamSubscription!.cancel();
      }
      LatLng coordinates = const LatLng(14.383, 120.9773);
      _streamSubscription = _gcpWeatherApiRepositoryImplementation.getWeatherData(SystemConstants().getGoogleCloudAPIKey, coordinates).listen((value) {
        add(DriverRideDisplayWeatherData(googleWeatherData: value));
      }, onDone: () {});
    });

    on<DriverRideDisplayWeatherData>((event, emit) {
      emit(DriverRideStatusWeatherDataLoaded(weatherDataFromAPI: event.googleWeatherData));
    });

    on<DriverSelectStartLocation>(
      (event, emit) async {
        print("Here is the event: ${event.startLocation}");

        if (_streamSubscription != null) {
          await _streamSubscription!.cancel();
        }
        if (event.startLocation == null) {
          print("BROOOOOOO GG");
        }
        GeocodingDataModel.GeocodingData geocodingData;
        if (event.startLocation != null) {
          print("Gumana ba to");
          geocodingData = await _gcpGeocodingDataRepositoryImplementation.getGeocodingDataFromAddress(event.startLocation!);
        } else {
          print("OR ITOOOO :<");
          geocodingData = await _gcpGeocodingDataRepositoryImplementation.getGeocodingDataFromAddress("Far Eastern University Alabang");
        }

        if (geocodingData.status == "OK") {
          print("Here is the possible start locations:");
          print("ADDING TO THE LIST");
          possibleStartLocations = [];

          //1. Add the current location as the first item in the list

          for (var i = 0; i < geocodingData.results.length; i++) {
            print("Here is the result: ${geocodingData.results[i].formattedAddress}");
            possibleStartLocations.add(geocodingData.results[i]);
          }

          print("Here is the possible start locations length: ${possibleStartLocations.length}");

          emit(DriverSelectingStartLocation(possibleStartLocations: possibleStartLocations));
        } else {
          emit(DriverSelectingStartLocation(possibleStartLocations: [
            GeocodingDataModel.Result(
              addressComponents: [],
              formattedAddress: "No Address Found",
              geometry: GeocodingDataModel.Geometry(
                  location: GeocodingDataModel.Location(lat: 14.383, lng: 120.9773), locationType: "POINT", viewport: GeocodingDataModel.Viewport(northeast: GeocodingDataModel.Location(lat: 14.383, lng: 120.9773), southwest: GeocodingDataModel.Location(lat: 14.383, lng: 120.9773))),
              placeId: "",
              plusCode: GeocodingDataModel.PlusCode(compoundCode: "", globalCode: ""),
              types: [],
            ),
          ]));
        }
      },
    );

    on<DriverPostRide>(
      (event, emit) {
        emit(const DriverPostRideFormDisplayed());
      },
    );

    on<DriverSelectDestination>((event, emit) async {
      print("Here is the event: ${event.destinationLocation}");

      if (_streamSubscription != null) {
        await _streamSubscription!.cancel();
      }
      if (event.destinationLocation == null) {
        print("BROOOOOOO GG");
      }
      GeocodingDataModel.GeocodingData geocodingData;
      if (event.destinationLocation != null) {
        print("Gumana ba to");
        geocodingData = await _gcpGeocodingDataRepositoryImplementation.getGeocodingDataFromAddress(event.destinationLocation!);
      } else {
        print("OR ITOOOO :<");
        geocodingData = await _gcpGeocodingDataRepositoryImplementation.getGeocodingDataFromAddress("Far Eastern University Alabang");
      }

      if (geocodingData.status == "OK") {
        print("Here is the possible start locations:");
        print("ADDING TO THE LIST");
        possibleDestinationList = [];

        //1. Add the current location as the first item in the list

        for (var i = 0; i < geocodingData.results.length; i++) {
          print("Here is the result: ${geocodingData.results[i].formattedAddress}");
          possibleDestinationList.add(geocodingData.results[i]);
        }

        print("Here is the possible start locations length: ${possibleDestinationList.length}");

        emit(DriverSelectingDestination(possibleDestinations: possibleDestinationList));
      } else {
        emit(DriverSelectingDestination(possibleDestinations: [
          GeocodingDataModel.Result(
            addressComponents: [],
            formattedAddress: "No Address Found",
            geometry: GeocodingDataModel.Geometry(
                location: GeocodingDataModel.Location(lat: 14.383, lng: 120.9773), locationType: "POINT", viewport: GeocodingDataModel.Viewport(northeast: GeocodingDataModel.Location(lat: 14.383, lng: 120.9773), southwest: GeocodingDataModel.Location(lat: 14.383, lng: 120.9773))),
            placeId: "",
            plusCode: GeocodingDataModel.PlusCode(compoundCode: "", globalCode: ""),
            types: [],
          ),
        ]));
      }
    });

    on<DriverInitializeConfirmRide>(
      (event, emit) async {
        List<LatLng> polylineCoordinates = [];
        Map<PolylineId, Polyline> generatedPolylines = {};
        GcpDistanceMatrixRepositoryImplementation gcpDistanceMatrixRepositoryImplementation = GcpDistanceMatrixRepositoryImplementation();
        // Current Location
        if (_streamSubscription != null) {
          await _streamSubscription!.cancel();
        }

        // Generate polylines
        print("Here is the start location formatted address: ${event.startLocationFormattedAddress}");
        print("Here is the destination formatted address: ${event.destinationFormattedAddress}");

        // Add State loading
        emit(DriverRideConfirmLoading());
        await Future.delayed(const Duration(seconds: 1));
        try {
          PolylineResult polylineResult = await PolylinePoints().getRouteBetweenCoordinates(
            SystemConstants().getGoogleCloudAPIKey,
            PointLatLng(event.startCoordinates.latitude, event.startCoordinates.longitude),
            PointLatLng(event.destinationCoordinates.latitude, event.destinationCoordinates.longitude),
            travelMode: TravelMode.driving,
          );
          if (polylineResult.points.isNotEmpty) {
            print("Here is the polyline points: ${polylineResult.points}");

            polylineResult.points.forEach((PointLatLng point) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });
            generatedPolylines[PolylineId("polyline_${generatedPolylines.length}")] = Polyline(
              polylineId: PolylineId("polyline_${generatedPolylines.length}"),
              color: const Color.fromARGB(255, 58, 104, 255),
              width: 7,
              onTap: () {},
              jointType: JointType.round,
              points: polylineCoordinates,
            );
            print("Generated polylines!");
            // distance
            GcpDistanceMatrixModel distanceMatrixData = await gcpDistanceMatrixRepositoryImplementation.getDistanceMatrixDataOnce(SystemConstants().google_cloud_api_key, event.startCoordinates, event.destinationCoordinates);
            print("Here is the distance matrix data: ${distanceMatrixData.rows[0].elements[0].distance.text}");
            print("Here is the duration matrix data: ${distanceMatrixData.rows[0].elements[0].duration.text}");
            // ETA

            emit(
              DriverRideConfirmDetails(
                polylines: generatedPolylines,
                distanceMatrix: distanceMatrixData.rows.first.elements.first.distance.text,
                durationMatrix: distanceMatrixData.rows.first.elements.first.duration.text,
                startLocationFormattedAddress: event.startLocationFormattedAddress,
                destinationFormattedAddress: event.destinationFormattedAddress,
                startCoordinates: event.startCoordinates,
                destinationCoordinates: event.destinationCoordinates,
                distance: distanceMatrixData.rows.first.elements.first.distance,
                duration: distanceMatrixData.rows.first.elements.first.duration,
              ),
            );
          } else {
            print("No polyline points found");
            emit(const DriverRideConfirmError(errorMessage: "No route found between the selected locations. Please try again."));
          }
        } catch (e) {
          print("Error in getting coordinates: $e");
          emit(const DriverRideConfirmError(errorMessage: "Error in getting route coordinates. Please try again."));
        }
        // calculate distance
        //https://maps.googleapis.com/maps/api/distancematrix/outputFormat?parameters

        // calculate ETA
      },
    );

    on<DriverRideStatusError>(
      (event, emit) {
        emit(DriverRideConfirmError(errorMessage: event.errorMessage));
      },
    );

    on<DriverStartRide>(
      (event, emit) async {
        print("RIDE STRTD");
        try {
          List<LatLng> polylineCoordinates = [];
          Map<PolylineId, Polyline> generatedPolylines = {};

          FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
          var rideInformationInstance = firebaseFirestore.collection("ride_information").doc(event.rideId);
          var rideInformationDocument = await rideInformationInstance.get();
          if (rideInformationDocument.exists) {
            print("RIDE STRTD 2");
            print("ri ${rideInformationDocument.data()!["ride_source_location"].latitude}");

            PolylineResult polylineResult = await PolylinePoints().getRouteBetweenCoordinates(
              SystemConstants().getGoogleCloudAPIKey,
              PointLatLng(rideInformationDocument.data()!["ride_source_location"].latitude, rideInformationDocument.data()!["ride_source_location"].longitude),
              PointLatLng(rideInformationDocument.data()!["ride_destination"].latitude, rideInformationDocument.data()!["ride_destination"].longitude),
              travelMode: TravelMode.driving,
            );

            print("rir ${rideInformationDocument.data()!["ride_source_location"].longitude}");

            if (polylineResult.points.isNotEmpty) {
              print("RIDE STRTD 3");
              print("Here is the polyline points: ${polylineResult.points}");

              polylineResult.points.forEach((PointLatLng point) {
                polylineCoordinates.add(LatLng(point.latitude, point.longitude));
              });
              generatedPolylines[PolylineId("polyline_${generatedPolylines.length}")] = Polyline(
                polylineId: PolylineId("polyline_${generatedPolylines.length}"),
                color: const Color.fromARGB(255, 58, 104, 255),
                width: 7,
                onTap: () {},
                jointType: JointType.round,
                points: polylineCoordinates,
              );
              emit(DriverRidePolylinesLoaded(generatedPolylines: generatedPolylines));
            }
          }
          await Future.delayed(const Duration(milliseconds: 100));

          _streamSubscription = _driverRideInformationRepositoryImplementation.getRideInformationByID(event.rideId).listen((onValue) async {
            print("repeatttt ${event.rideId}");
            add(DriverStartLoadingPassengers(rideInformation: onValue, generatedPolylines: generatedPolylines));
          });
        } catch (error) {
          emit(DriverRideConfirmError(errorMessage: error.toString()));
        }
      },
    );

    on<DriverStartLoadingPassengers>((event, emit) {
      emit(DriverRidePassengersLoaded(
        rideInformation: event.rideInformation,
      ));
    });
    on<DriverCompleteRide>((event, emit) {
      emit(DriverRideCompleted(rideInformation: event.rideInformation));
    });
  }
}
