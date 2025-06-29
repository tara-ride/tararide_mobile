part of 'driver_ride_status_bloc.dart';

sealed class DriverRideStatusEvent extends Equatable {
  const DriverRideStatusEvent();

  @override
  List<Object> get props => [];
}

class DriverRideInitialize extends DriverRideStatusEvent {
  const DriverRideInitialize();

  @override
  List<Object> get props => [];
}

final class DriverRideStatusLoadWeatherData extends DriverRideStatusEvent {
  const DriverRideStatusLoadWeatherData();

  @override
  List<Object> get props => [];
}

final class DriverRideDisplayWeatherData extends DriverRideStatusEvent {
  final GoogleWeatherData googleWeatherData;

  const DriverRideDisplayWeatherData({required this.googleWeatherData});

  @override
  List<Object> get props => [googleWeatherData];
}

final class DriverSelectStartLocation extends DriverRideStatusEvent {
  final String? startLocation;
  const DriverSelectStartLocation({this.startLocation});

  @override
  List<Object> get props => [startLocation ?? ''];
}

final class DriverSelectDestination extends DriverRideStatusEvent {
  final String? destinationLocation;
  const DriverSelectDestination({this.destinationLocation});

  @override
  List<Object> get props => [destinationLocation ?? ''];
}

final class DriverPostRide extends DriverRideStatusEvent {
  const DriverPostRide();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class DriverInitializeConfirmRide extends DriverRideStatusEvent {
  String startLocationFormattedAddress;
  String destinationFormattedAddress;
  LatLng startCoordinates;
  LatLng destinationCoordinates;

  DriverInitializeConfirmRide({
    required this.startLocationFormattedAddress,
    required this.destinationFormattedAddress,
    required this.startCoordinates,
    required this.destinationCoordinates,
  });
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class DriverRideStatusError extends DriverRideStatusEvent {
  String errorMessage;

  DriverRideStatusError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// ignore: must_be_immutable
final class DriverStartRide extends DriverRideStatusEvent {
  String rideId;

  DriverStartRide({required this.rideId});

  @override
  List<Object> get props => [rideId];
}

final class DriverStartLoadingPassengers extends DriverRideStatusEvent {
  final RideInformationModel rideInformation;
  final Map<PolylineId, Polyline> generatedPolylines;

  const DriverStartLoadingPassengers({required this.generatedPolylines, required this.rideInformation});

  @override
  List<Object> get props => [rideInformation, generatedPolylines];
}

// ignore: must_be_immutable
final class DriverCompleteRide extends DriverRideStatusEvent {
  RideInformationModel rideInformation;
  DriverCompleteRide({required this.rideInformation});

  @override
  List<Object> get props => [rideInformation];
}
