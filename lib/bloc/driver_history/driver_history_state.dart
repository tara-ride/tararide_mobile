part of 'driver_history_bloc.dart';

sealed class DriverHistoryState extends Equatable {
  const DriverHistoryState();

  @override
  List<Object> get props => [];
}

final class DriverHistoryInitial extends DriverHistoryState {}

final class DriverHistoryListLoaded extends DriverHistoryState {
  final List<RideInformationModel> rideInformationList;

  DriverHistoryListLoaded({required this.rideInformationList});

  @override
  List<Object> get props => [rideInformationList];
}

final class DriverHistoryDetailsLoaded extends DriverHistoryState {
  final RideInformationModel rideInformationList;

  const DriverHistoryDetailsLoaded({required this.rideInformationList});

  @override
  List<Object> get props => [rideInformationList];
}

final class DriverHistoryCommonError extends DriverHistoryState {
  final String error;

  const DriverHistoryCommonError({required this.error});

  @override
  List<Object> get props => [error];
}
