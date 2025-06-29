part of 'passenger_ride_status_bloc.dart';

sealed class PassengerRideStatusEvent extends Equatable {
  const PassengerRideStatusEvent();

  @override
  List<Object> get props => [];
}

final class PassengerRideStatusInitialize extends PassengerRideStatusEvent {}

final class PassengerRideStatusLoadWeatherData extends PassengerRideStatusEvent {
  const PassengerRideStatusLoadWeatherData();

  @override
  List<Object> get props => [];
}

final class PassengerRideStatusDisplayWeatherData extends PassengerRideStatusEvent {
  final GoogleWeatherData googleWeatherData;

  const PassengerRideStatusDisplayWeatherData({required this.googleWeatherData});

  @override
  List<Object> get props => [googleWeatherData];
}

final class PassengerSelectPickupLocation extends PassengerRideStatusEvent {
  final String? pickupLocation;
  const PassengerSelectPickupLocation({this.pickupLocation});

  @override
  List<Object> get props => [pickupLocation ?? ''];
}

final class PassengerSelectDestination extends PassengerRideStatusEvent {
  final String? destinationLocation;
  const PassengerSelectDestination({this.destinationLocation});

  @override
  List<Object> get props => [destinationLocation ?? ''];
}

// ignore: must_be_immutable
final class PassengerInitializeConfirmRide extends PassengerRideStatusEvent {
  String pickupLocationFormattedAddress;
  String destinationFormattedAddress;
  LatLng pickupCoordinates;
  LatLng destinationCoordinates;

  PassengerInitializeConfirmRide({
    required this.pickupLocationFormattedAddress,
    required this.destinationFormattedAddress,
    required this.pickupCoordinates,
    required this.destinationCoordinates,
  });
  @override
  List<Object> get props => [];
}

final class PassengerConfirmRide extends PassengerRideStatusEvent {
  final String estimatedTime;
  final double rideDistance;
  final int slotsToOccupy;
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final String pickupLocationFormattedAddress;
  final String destinationFormattedAddress;

  const PassengerConfirmRide({
    required this.pickupLocation,
    required this.estimatedTime,
    required this.rideDistance,
    required this.slotsToOccupy,
    required this.destinationLocation,
    required this.pickupLocationFormattedAddress,
    required this.destinationFormattedAddress,
  });

  @override
  List<Object> get props => [
        pickupLocation,
        estimatedTime,
        rideDistance,
        slotsToOccupy,
        destinationLocation,
      ];
}

final class PassengerSelectRide extends PassengerRideStatusEvent {
  final String estimatedTime;
  final double rideDistance;
  final int slotsToOccupy;
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final String pickupLocationFormattedAddress;
  final String destinationFormattedAddress;
  final bool isRideSelected;

  const PassengerSelectRide({
    required this.pickupLocation,
    required this.estimatedTime,
    required this.rideDistance,
    required this.slotsToOccupy,
    required this.destinationLocation,
    required this.pickupLocationFormattedAddress,
    required this.destinationFormattedAddress,
    this.isRideSelected = false,
  });

  @override
  List<Object> get props => [
        pickupLocation,
        estimatedTime,
        rideDistance,
        slotsToOccupy,
        destinationLocation,
      ];
}

final class PassengerLoadAvailableRides extends PassengerRideStatusEvent {
  final String estimatedTime;
  final double rideDistance;
  final int slotsToOccupy;
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final List<RideInformationModel> rideInformationList;
  final String pickupLocationFormattedAddress;
  final String destinationFormattedAddress;

  const PassengerLoadAvailableRides({
    required this.pickupLocation,
    required this.estimatedTime,
    required this.rideDistance,
    required this.slotsToOccupy,
    required this.rideInformationList,
    required this.destinationLocation,
    required this.pickupLocationFormattedAddress,
    required this.destinationFormattedAddress,
  });

  @override
  List<Object> get props => [
        pickupLocation,
        estimatedTime,
        rideDistance,
        slotsToOccupy,
        pickupLocationFormattedAddress,
        destinationFormattedAddress,
        rideInformationList,
        destinationLocation,
      ];
}

// ignore: must_be_immutable
final class PassengerRideStart extends PassengerRideStatusEvent {
  String rideId;

  PassengerRideStart({required this.rideId});
}

final class PassengerRideStartedDetails extends PassengerRideStatusEvent {
  final RideInformationModel rideInformation;
  final Map<PolylineId, Polyline> generatedPolylines;

  const PassengerRideStartedDetails({required this.generatedPolylines, required this.rideInformation});

  @override
  List<Object> get props => [rideInformation, generatedPolylines];
}

final class PassengerRideProgress extends PassengerRideStatusEvent {
  final String rideId;

  const PassengerRideProgress({required this.rideId});
  @override
  List<Object> get props => [rideId];
}

final class PassengerRideProgressUpdate extends PassengerRideStatusEvent {
  final RideInformationModel rideInformation;

  const PassengerRideProgressUpdate({required this.rideInformation});
  @override
  List<Object> get props => [rideInformation];
}

final class PassengerRidePaymentStart extends PassengerRideStatusEvent {
  final String rideId;
  const PassengerRidePaymentStart({required this.rideId});
  @override
  List<Object> get props => [rideId];
}

final class PassengerRideFeedbackStart extends PassengerRideStatusEvent {
  final String rideId;
  const PassengerRideFeedbackStart({required this.rideId});
  @override
  List<Object> get props => [rideId];
}

final class PassengerRideFeedbackComplete extends PassengerRideStatusEvent {}
