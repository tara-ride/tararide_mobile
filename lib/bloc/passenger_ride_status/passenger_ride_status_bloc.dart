import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tararide_mobile/config/firebase_options.dart';
import 'package:tararide_mobile/models/geocoding_data.dart' as GeocodingDataModel;
import 'package:tararide_mobile/models/google_weather_data.dart';
import 'package:tararide_mobile/repository/gcp_geocoding_data.dart';
import 'package:tararide_mobile/repository/gcp_weather_api_repository.dart';
import 'package:geocoding/geocoding.dart';

part 'passenger_ride_status_event.dart';
part 'passenger_ride_status_state.dart';

class PassengerRideStatusBloc extends Bloc<PassengerRideStatusEvent, PassengerRideStatusState> {
  final GcpWeatherApiRepositoryImplementation _gcpWeatherApiRepositoryImplementation;
  GcpGeocodingDataRepositoryImplementation _gcpGeocodingDataRepositoryImplementation = GcpGeocodingDataRepositoryImplementation();
  StreamSubscription? _streamSubscription;
  StreamSubscription? _gcpGeocodingDataStreamSubscription;
  List<GeocodingDataModel.Result> possiblePickupLocations = [];

  PassengerRideStatusBloc(this._gcpWeatherApiRepositoryImplementation) : super(PassengerSelectingPickupLocation(possiblePickupLocations: [])) {
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
        // print("Pickup Location: ${event.pickupLocation}");
        // if (_streamSubscription != null) {
        //   await _streamSubscription!.cancel();
        // }
        // _streamSubscription = _gcpGeocodingDataRepositoryImplementation.getGeocodingData(event.pickupLocation ?? "FEU Alabang").listen((value) {
        //   print("Here is the value: $value");
        //   // print("Pickup Location: ${event.pickupLocation}");
        //   add(PassengerSelectPickupLocation(pickupLocation: value));
        // }, onDone: () {});

        // if (event.pickupLocation != null) {
        //   List<Location> possiblePickupLocations = [];
        //   try {
        //     possiblePickupLocations = await locationFromAddress(event.pickupLocation!);
        //   } catch (e) {
        //     print("Error: $e");
        //   }

        //   emit(PassengerSelectingPickupLocation(possiblePickupLocations: possiblePickupLocations));
        // } else {
        //   emit(PassengerSelectingPickupLocation(possiblePickupLocations: [
        //     Location(latitude: 14.383, longitude: 120.9773, timestamp: DateTime.now()),
        //   ]));
        // }

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
      (event, emit) {
        emit(PassengerSelectingDestination());
      },
    );

    on<PassengerSelectRide>(
      (event, emit) {
        emit(PassengerSelectingRide());
      },
    );

    on<PassengerRideStart>(
      (event, emit) {
        emit(PassengerRideStarted());
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
