part of 'driver_ride_status_bloc.dart';

sealed class DriverRideStatusState extends Equatable {
  const DriverRideStatusState();

  @override
  List<Object> get props => [];
}

final class DriverRideStatusInitial extends DriverRideStatusState {
  const DriverRideStatusInitial();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class DriverRideStatusWeatherDataLoaded extends DriverRideStatusState {
  GoogleWeatherData weatherDataFromAPI;

  DriverRideStatusWeatherDataLoaded({required this.weatherDataFromAPI});
  @override
  List<Object> get props => [weatherDataFromAPI];
}

final class DriverPostRideFormDisplayed extends DriverRideStatusState {
  const DriverPostRideFormDisplayed();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class DriverSelectingStartLocation extends DriverRideStatusState {
  List<GeocodingDataModel.Result> possibleStartLocations;

  DriverSelectingStartLocation({
    required this.possibleStartLocations,
  });
  @override
  List<Object> get props => [possibleStartLocations];
}

final class DriverSelectingDestination extends DriverRideStatusState {
  final List<GeocodingDataModel.Result> possibleDestinations;

  const DriverSelectingDestination({
    required this.possibleDestinations,
  });
  @override
  List<Object> get props => [possibleDestinations];
}

final class DriverRideConfirmLoading extends DriverRideStatusState {
  const DriverRideConfirmLoading();
  @override
  List<Object> get props => [];
}

final class DriverRideConfirmDetails extends DriverRideStatusState {
  final String startLocationFormattedAddress;
  final String destinationFormattedAddress;
  final LatLng startCoordinates;
  final LatLng destinationCoordinates;
  final Map<PolylineId, Polyline> polylines;
  final String distanceMatrix;
  final String durationMatrix;
  final Distance distance;
  final Distance duration;

  const DriverRideConfirmDetails({
    required this.distanceMatrix,
    required this.durationMatrix,
    required this.polylines,
    required this.startLocationFormattedAddress,
    required this.destinationFormattedAddress,
    required this.startCoordinates,
    required this.destinationCoordinates,
    required this.distance,
    required this.duration,
  });
  @override
  List<Object> get props => [
        startLocationFormattedAddress,
        destinationFormattedAddress,
        startCoordinates,
        destinationCoordinates,
        polylines,
        distanceMatrix,
        durationMatrix,
        distance,
        duration,
      ];
}

final class DriverRideConfirmError extends DriverRideStatusState {
  final String errorMessage;

  const DriverRideConfirmError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class DriverRideStarted extends DriverRideStatusState {
  // final String ride

  const DriverRideStarted();
  @override
  List<Object> get props => [];
}

final class DriverRidePolylinesLoaded extends DriverRideStatusState {
  final Map<PolylineId, Polyline> generatedPolylines;

  DriverRidePolylinesLoaded({required this.generatedPolylines});

  @override
  List<Object> get props => [generatedPolylines];
}

final class DriverRidePassengersLoaded extends DriverRideStatusState {
  final RideInformationModel rideInformation;

  const DriverRidePassengersLoaded({required this.rideInformation});
  @override
  List<Object> get props => [rideInformation];
}

// ignore: must_be_immutable
final class DriverRideCompleted extends DriverRideStatusState {
  // final String ride
  RideInformationModel rideInformation;

  DriverRideCompleted({required this.rideInformation});
  @override
  List<Object> get props => [rideInformation];
}
