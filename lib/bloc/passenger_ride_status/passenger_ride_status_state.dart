part of 'passenger_ride_status_bloc.dart';

sealed class PassengerRideStatusState extends Equatable {
  const PassengerRideStatusState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class PassengerRideStatusInitial extends PassengerRideStatusState {}

// ignore: must_be_immutable
final class PassengerRideStatusWeatherDataLoaded extends PassengerRideStatusState {
  GoogleWeatherData weatherDataFromAPI;

  PassengerRideStatusWeatherDataLoaded({required this.weatherDataFromAPI});
  @override
  List<Object> get props => [weatherDataFromAPI];
}

// ignore: must_be_immutable
final class PassengerSelectingPickupLocation extends PassengerRideStatusState {
  List<GeocodingDataModel.Result> possiblePickupLocations;

  PassengerSelectingPickupLocation({
    required this.possiblePickupLocations,
  });
  @override
  List<Object> get props => [possiblePickupLocations];
}

final class PassengerSelectingDestination extends PassengerRideStatusState {
  @override
  List<Object> get props => [];
}

final class PassengerSelectingRide extends PassengerRideStatusState {
  @override
  List<Object> get props => [];
}

final class PassengerRideStarted extends PassengerRideStatusState {}

final class PassengerRideInProgress extends PassengerRideStatusState {}

final class PassengerRidePaymentStarted extends PassengerRideStatusState {}

final class PassengerRideFeedbackStarted extends PassengerRideStatusState {}

final class PassengerRideFeedbackCompleted extends PassengerRideStatusState {}
