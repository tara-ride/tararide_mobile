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
