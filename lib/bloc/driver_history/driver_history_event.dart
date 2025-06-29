part of 'driver_history_bloc.dart';

sealed class DriverHistoryEvent extends Equatable {
  const DriverHistoryEvent();

  @override
  List<Object> get props => [];
}

final class DriverHistory extends DriverHistoryEvent {
  @override
  List<Object> get props => [];
}

final class DriverHistoryLoadList extends DriverHistoryEvent {
  @override
  List<Object> get props => [];
}

final class DriverHistoryDisplayList extends DriverHistoryEvent {
  final List<RideInformationModel> rideInformationList;

  DriverHistoryDisplayList({required this.rideInformationList});

  @override
  List<Object> get props => [rideInformationList];
}

final class DisplayDriverHistoryDetails extends DriverHistoryEvent {
  final RideInformationModel rideInformation;

  const DisplayDriverHistoryDetails({required this.rideInformation});
  @override
  List<Object> get props => [rideInformation];
}
