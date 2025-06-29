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
  final List<GeocodingDataModel.Result> possibleDestinations;

  const PassengerSelectingDestination({
    required this.possibleDestinations,
  });
  @override
  List<Object> get props => [possibleDestinations];
}

final class PassengerRideConfirmDetails extends PassengerRideStatusState {
  final String pickupLocationFormattedAddress;
  final String destinationFormattedAddress;
  final LatLng pickupCoordinates;
  final LatLng destinationCoordinates;
  final Map<PolylineId, Polyline> polylines;
  final String distanceMatrix;
  final String durationMatrix;
  final Distance distance;
  final Distance duration;

  const PassengerRideConfirmDetails({
    required this.distanceMatrix,
    required this.durationMatrix,
    required this.polylines,
    required this.pickupLocationFormattedAddress,
    required this.destinationFormattedAddress,
    required this.pickupCoordinates,
    required this.destinationCoordinates,
    required this.distance,
    required this.duration,
  });
  @override
  List<Object> get props => [
        pickupLocationFormattedAddress,
        destinationFormattedAddress,
        pickupCoordinates,
        destinationCoordinates,
        polylines,
        distanceMatrix,
        durationMatrix,
        distance,
        duration,
      ];
}

final class PassengerRideConfirmation extends PassengerRideStatusState {
  final double estimatedFare;
  final String estimatedTime;
  final String rideDistance;
  final String slotsToOccupy;
  final String pickupLocation;
  final String destinationLocation;

  const PassengerRideConfirmation({
    required this.pickupLocation,
    required this.estimatedFare,
    required this.estimatedTime,
    required this.rideDistance,
    required this.slotsToOccupy,
    required this.destinationLocation,
  });

  @override
  List<Object> get props => [estimatedFare, estimatedTime, rideDistance, slotsToOccupy, pickupLocation, destinationLocation];
}

final class PassengerRideConfirmLoading extends PassengerRideStatusState {
  // pickupLocationFormattedAddress: '',
  //               destinationFormattedAddress: '',
  //               pickupCoordinates: LatLng(14.12, 120.98),
  //               destinationCoordinates: LatLng(14.12, 120.98),

  const PassengerRideConfirmLoading();
  @override
  List<Object> get props => [];
}

final class PassengerRideConfirmError extends PassengerRideStatusState {
  final String errorMessage;

  const PassengerRideConfirmError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class PassengerSelectingRide extends PassengerRideStatusState {
  final String estimatedTime;
  final double rideDistance;
  final int slotsToOccupy;
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final String pickupLocationFormattedAddress;
  final List<RideInformationModel> rideInformationList;
  final String destinationFormattedAddress;

  const PassengerSelectingRide({
    required this.pickupLocation,
    required this.estimatedTime,
    required this.rideDistance,
    required this.slotsToOccupy,
    required this.destinationLocation,
    required this.pickupLocationFormattedAddress,
    required this.destinationFormattedAddress,
    required this.rideInformationList,
  });
  @override
  List<Object> get props => [
        pickupLocation,
        estimatedTime,
        rideDistance,
        slotsToOccupy,
        destinationLocation,
        pickupLocationFormattedAddress,
        destinationFormattedAddress,
        rideInformationList,
      ];
}

final class PassengerRideDataFailure extends PassengerRideStatusState {}

// ignore: must_be_immutable
final class PassengerRideStarted extends PassengerRideStatusState {
  final RideInformationModel rideInformation;
  final Map<PolylineId, Polyline> generatedPolylines;

  const PassengerRideStarted({required this.generatedPolylines, required this.rideInformation});

  @override
  List<Object> get props => [rideInformation, generatedPolylines];
}
//emit(DriverRidePolylinesLoaded(generatedPolylines: generatedPolylines));

final class PassengerRidePolylinesLoaded extends PassengerRideStatusState {
  final Map<PolylineId, Polyline> generatedPolylines;

  PassengerRidePolylinesLoaded({required this.generatedPolylines});

  @override
  List<Object> get props => [generatedPolylines];
}

final class PassengerRideInProgress extends PassengerRideStatusState {
  final RideInformationModel rideInformation;

  const PassengerRideInProgress({required this.rideInformation});
  @override
  List<Object> get props => [
        rideInformation,
      ];
}

final class PassengerRidePaymentStarted extends PassengerRideStatusState {
  final RideInformationModel rideInformation;

  const PassengerRidePaymentStarted({required this.rideInformation});
  @override
  List<Object> get props => [
        rideInformation,
      ];
}

final class PassengerRideFeedbackStarted extends PassengerRideStatusState {
  final RideInformationModel rideInformation;

  const PassengerRideFeedbackStarted({required this.rideInformation});
  @override
  List<Object> get props => [
        rideInformation,
      ];
}

final class PassengerRideFeedbackCompleted extends PassengerRideStatusState {}
