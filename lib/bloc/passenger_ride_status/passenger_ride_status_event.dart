part of 'passenger_ride_status_bloc.dart';

sealed class PassengerRideStatusEvent extends Equatable {
  const PassengerRideStatusEvent();

  @override
  List<Object> get props => [];
}

final class PassengerRideStatusInitialize extends PassengerRideStatusEvent {}

final class PassengerSelectPickupLocation extends PassengerRideStatusEvent {}

final class PassengerSelectDestination extends PassengerRideStatusEvent {}

final class PassengerSelectRide extends PassengerRideStatusEvent {}

final class PassengerRideStart extends PassengerRideStatusEvent {}

final class PassengerRidePaymentStart extends PassengerRideStatusEvent {}

final class PassengerRideFeedbackStart extends PassengerRideStatusEvent {}

final class PassengerRideFeedbackComplete extends PassengerRideStatusEvent {}
