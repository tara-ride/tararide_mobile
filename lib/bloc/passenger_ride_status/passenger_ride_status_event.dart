part of 'passenger_ride_status_bloc.dart';

sealed class PassengerRideStatusEvent extends Equatable {
  const PassengerRideStatusEvent();

  @override
  List<Object> get props => [];
}

final class PassengerRideStatusInitialize extends PassengerRideStatusEvent {}

final class PassengerRideStatusLoadWeatherData extends PassengerRideStatusEvent {
  final GoogleWeatherData googleWeatherData;

  const PassengerRideStatusLoadWeatherData({required this.googleWeatherData});

  @override
  List<Object> get props => [googleWeatherData];
}

final class PassengerSelectPickupLocation extends PassengerRideStatusEvent {
  final String? pickupLocation;
  const PassengerSelectPickupLocation({this.pickupLocation});

  @override
  List<Object> get props => [pickupLocation ?? ''];
}

final class PassengerSelectDestination extends PassengerRideStatusEvent {}

final class PassengerSelectRide extends PassengerRideStatusEvent {
  const PassengerSelectRide();

  @override
  List<Object> get props => [];
}

final class PassengerRideStart extends PassengerRideStatusEvent {}

final class PassengerRideProgress extends PassengerRideStatusEvent {}

final class PassengerRidePaymentStart extends PassengerRideStatusEvent {}

final class PassengerRideFeedbackStart extends PassengerRideStatusEvent {}

final class PassengerRideFeedbackComplete extends PassengerRideStatusEvent {}
