part of 'passenger_ride_status_bloc.dart';

sealed class PassengerRideStatusState extends Equatable {
  const PassengerRideStatusState();

  @override
  List<Object> get props => [];
}

final class PassengerRideStatusInitial extends PassengerRideStatusState {
  @override
  List<Object> get props => [];
}

final class PassengerSelectingPickupLocation extends PassengerRideStatusState {
  @override
  List<Object> get props => [];
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

final class PassengerRidePaymentStarted extends PassengerRideStatusState {}

final class PassengerRideFeedbackStarted extends PassengerRideStatusState {}

final class PassengerRideFeedbackCompleted extends PassengerRideStatusState {}
