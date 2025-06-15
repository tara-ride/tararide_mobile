import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tararide_mobile/config/firebase_options.dart';
import 'package:tararide_mobile/models/geocoding_data.dart' as GeocodingDataModel;
import 'package:tararide_mobile/models/google_distance_matrix_data.dart';
import 'package:tararide_mobile/models/google_weather_data.dart';
import 'package:tararide_mobile/repository/gcp_geocoding_data.dart';
import 'package:tararide_mobile/repository/gcp_weather_api_repository.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tararide_mobile/repository/passenger_ride_information_repository.dart';

import '../../models/ride_information_data.dart';
import '../../repository/gcp_distance_matrix_repository.dart';

part 'passenger_ride_status_event.dart';
part 'passenger_ride_status_state.dart';

class PassengerRideStatusBloc extends Bloc<PassengerRideStatusEvent, PassengerRideStatusState> {
  final GcpWeatherApiRepositoryImplementation _gcpWeatherApiRepositoryImplementation;
  GcpGeocodingDataRepositoryImplementation _gcpGeocodingDataRepositoryImplementation = GcpGeocodingDataRepositoryImplementation();
  PassengerRideInformationRepositoryImplementation passengerRideInformationRepositoryImplementation = PassengerRideInformationRepositoryImplementation();
  StreamSubscription? _streamSubscription;
  StreamSubscription? _gcpGeocodingDataStreamSubscription;
  List<GeocodingDataModel.Result> possiblePickupLocations = [];
  List<GeocodingDataModel.Result> possibleDestinationList = [];

  PassengerRideStatusBloc(this._gcpWeatherApiRepositoryImplementation) : super(PassengerRideStatusInitial()) {
    on<PassengerRideStatusInitialize>(
      (event, emit) async {
        if (_streamSubscription != null) {
          await _streamSubscription!.cancel();
        }
        if (_gcpGeocodingDataStreamSubscription != null) {
          await _gcpGeocodingDataStreamSubscription!.cancel();
        }
        LatLng coordinates = const LatLng(14.383, 120.9773);
        _streamSubscription = _gcpWeatherApiRepositoryImplementation.getWeatherData(SystemConstants().getGoogleCloudAPIKey, coordinates).listen((value) {
          add(PassengerRideStatusLoadWeatherData(googleWeatherData: value));
        }, onDone: () {});
      },
    );

    on<PassengerRideStatusLoadWeatherData>(
      (event, emit) {
        emit(PassengerRideStatusWeatherDataLoaded(weatherDataFromAPI: event.googleWeatherData));
      },
    );

    on<PassengerSelectPickupLocation>(
      (event, emit) async {
        print("Here is the event: ${event.pickupLocation}");

        if (_streamSubscription != null) {
          await _streamSubscription!.cancel();
        }
        if (event.pickupLocation == null) {
          print("BROOOOOOO GG");
        }
        GeocodingDataModel.GeocodingData geocodingData;
        if (event.pickupLocation != null) {
          print("Gumana ba to");
          geocodingData = await _gcpGeocodingDataRepositoryImplementation.getGeocodingDataFromAddress(event.pickupLocation!);
        } else {
          print("OR ITOOOO :<");
          geocodingData = await _gcpGeocodingDataRepositoryImplementation.getGeocodingDataFromAddress("Far Eastern University Alabang");
        }

        if (geocodingData.status == "OK") {
          print("Here is the possible pickup locations:");
          print("ADDING TO THE LIST");
          possiblePickupLocations = [];

          //1. Add the current location as the first item in the list

          for (var i = 0; i < geocodingData.results.length; i++) {
            print("Here is the result: ${geocodingData.results[i].formattedAddress}");
            possiblePickupLocations.add(geocodingData.results[i]);
          }

          print("Here is the possible pickup locations length: ${possiblePickupLocations.length}");

          emit(PassengerSelectingPickupLocation(possiblePickupLocations: possiblePickupLocations));
        } else {
          emit(PassengerSelectingPickupLocation(possiblePickupLocations: [
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

    on<PassengerSelectDestination>(
      (event, emit) async {
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
          print("Here is the possible pickup locations:");
          print("ADDING TO THE LIST");
          possibleDestinationList = [];

          //1. Add the current location as the first item in the list

          for (var i = 0; i < geocodingData.results.length; i++) {
            print("Here is the result: ${geocodingData.results[i].formattedAddress}");
            possibleDestinationList.add(geocodingData.results[i]);
          }

          print("Here is the possible pickup locations length: ${possibleDestinationList.length}");

          emit(PassengerSelectingDestination(possibleDestinations: possibleDestinationList));
        } else {
          emit(PassengerSelectingDestination(possibleDestinations: [
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

    on<PassengerInitializeConfirmRide>(
      (event, emit) async {
        List<LatLng> polylineCoordinates = [];
        Map<PolylineId, Polyline> generatedPolylines = {};
        GcpDistanceMatrixRepositoryImplementation gcpDistanceMatrixRepositoryImplementation = GcpDistanceMatrixRepositoryImplementation();
        // Current Location
        if (_streamSubscription != null) {
          await _streamSubscription!.cancel();
        }

        // Generate polylines
        print("Here is the pickup location formatted address: ${event.pickupLocationFormattedAddress}");
        print("Here is the destination formatted address: ${event.destinationFormattedAddress}");

        // Add State loading
        emit(PassengerRideConfirmLoading());
        await Future.delayed(const Duration(seconds: 1));
        try {
          PolylineResult polylineResult = await PolylinePoints().getRouteBetweenCoordinates(
            SystemConstants().getGoogleCloudAPIKey,
            PointLatLng(event.pickupCoordinates.latitude, event.pickupCoordinates.longitude),
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
              color: const Color.fromARGB(255, 0, 125, 31),
              width: 5,
              points: polylineCoordinates,
            );
            print("Generated polylines!");
            // distance
            GcpDistanceMatrixModel distanceMatrixData = await gcpDistanceMatrixRepositoryImplementation.getDistanceMatrixDataOnce(SystemConstants().google_cloud_api_key, event.pickupCoordinates, event.destinationCoordinates);
            print("Here is the distance matrix data: ${distanceMatrixData.rows[0].elements[0].distance.text}");
            print("Here is the duration matrix data: ${distanceMatrixData.rows[0].elements[0].duration.text}");
            // ETA

            emit(
              PassengerRideConfirmDetails(
                polylines: generatedPolylines,
                distanceMatrix: distanceMatrixData.rows.first.elements.first.distance.text,
                durationMatrix: distanceMatrixData.rows.first.elements.first.duration.text,
                pickupLocationFormattedAddress: event.pickupLocationFormattedAddress,
                destinationFormattedAddress: event.destinationFormattedAddress,
                pickupCoordinates: event.pickupCoordinates,
                destinationCoordinates: event.destinationCoordinates,
                distance: distanceMatrixData.rows.first.elements.first.distance,
                duration: distanceMatrixData.rows.first.elements.first.duration,
              ),
            );
          } else {
            print("No polyline points found");
            emit(const PassengerRideConfirmError(errorMessage: "No route found between the selected locations. Please try again."));
          }
        } catch (e) {
          print("Error in getting coordinates: $e");
          emit(const PassengerRideConfirmError(errorMessage: "Error in getting route coordinates. Please try again."));
        }

        // calculate distance
        //https://maps.googleapis.com/maps/api/distancematrix/outputFormat?parameters

        // calculate ETA
      },
    );

    on<PassengerConfirmRide>(
      (event, emit) {
        add(PassengerSelectRide(
          pickupLocation: event.pickupLocation,
          estimatedTime: event.estimatedTime,
          rideDistance: event.rideDistance,
          slotsToOccupy: event.slotsToOccupy,
          destinationLocation: event.destinationLocation,
          pickupLocationFormattedAddress: event.pickupLocationFormattedAddress,
          destinationFormattedAddress: event.destinationFormattedAddress,
        ));
      },
    );

    on<PassengerSelectRide>(
      (event, emit) async {
        // No need to initialize rideInformationListInstance here if you're populating it in the listener
        // List<RideInformationModel> rideInformationListInstance = []; // Remove this line

        // add(PassengerLoadAvailableRides(
        //   pickupLocation: event.pickupLocation,
        //   estimatedTime: event.estimatedTime,
        //   rideDistance: event.rideDistance,
        //   slotsToOccupy: event.slotsToOccupy,
        //   destinationLocation: event.destinationLocation,
        //   //Pass the ride information list
        //   pickupLocationFormattedAddress: event.pickupLocationFormattedAddress,
        //   destinationFormattedAddress: event.destinationFormattedAddress,
        // ));
        if (_streamSubscription != null) {
          _streamSubscription!.cancel();
        }
        try {
          _streamSubscription = passengerRideInformationRepositoryImplementation.getPassengerRideInformationListStream().listen((onValue) {
            add(PassengerLoadAvailableRides(
              pickupLocation: event.pickupLocation,
              estimatedTime: event.estimatedTime,
              rideDistance: event.rideDistance,
              slotsToOccupy: event.slotsToOccupy,
              destinationLocation: event.destinationLocation,
              rideInformationList: onValue,
              pickupLocationFormattedAddress: event.pickupLocationFormattedAddress,
              destinationFormattedAddress: event.destinationFormattedAddress,
            ));
          });
        } catch (error) {
          emit(PassengerRideDataFailure());
        }
      },
    );
    on<PassengerLoadAvailableRides>(
      (event, emit) async {
        emit(
          PassengerSelectingRide(
            pickupLocation: event.pickupLocation,
            estimatedTime: event.estimatedTime,
            rideDistance: event.rideDistance,
            slotsToOccupy: event.slotsToOccupy,
            destinationLocation: event.destinationLocation,
            rideInformationList: event.rideInformationList, // Provide an empty list or an error specific list
            pickupLocationFormattedAddress: event.pickupLocationFormattedAddress,
            destinationFormattedAddress: event.destinationFormattedAddress,
          ),
        );
      },
    );
    on<PassengerRideStart>(
      (event, emit) {
        emit(PassengerRideStarted(rideId: event.rideId));
      },
    );
    on<PassengerRideProgress>(
      (event, emit) {
        emit(PassengerRideInProgress());
      },
    );

    on<PassengerRidePaymentStart>(
      (event, emit) {
        emit(PassengerRidePaymentStarted());
      },
    );
    on<PassengerRideFeedbackStart>(
      (event, emit) {
        emit(PassengerRideFeedbackStarted());
      },
    );

    on<PassengerRideFeedbackComplete>(
      (event, emit) {
        emit(PassengerRideFeedbackCompleted());
      },
    );
  }
}
