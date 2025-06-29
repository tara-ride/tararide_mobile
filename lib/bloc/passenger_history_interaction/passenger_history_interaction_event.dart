part of 'passenger_history_interaction_bloc.dart';

sealed class PassengerHistoryInteractionEvent extends Equatable {
  const PassengerHistoryInteractionEvent();

  @override
  List<Object> get props => [];
}

final class LoadPassengerHistoryInteraction extends PassengerHistoryInteractionEvent {
  @override
  List<Object> get props => [];
}

final class InitializePassengerHistoryInteraction extends PassengerHistoryInteractionEvent {
  final PassengerHistoryInteractionData historyInteractionData;

  const InitializePassengerHistoryInteraction({required this.historyInteractionData});

  @override
  List<Object> get props => [historyInteractionData];
}

final class PassengerHistoryInteractionLoadList extends PassengerHistoryInteractionEvent {
  final List<PassengerHistoryInteractionData> historyInteractionDataList;

  const PassengerHistoryInteractionLoadList({required this.historyInteractionDataList});

  @override
  List<Object> get props => [historyInteractionDataList];
}

final class InitializePassengerHistoryInteractionList extends PassengerHistoryInteractionEvent {
  final String uuid;

  const InitializePassengerHistoryInteractionList({required this.uuid, required});

  @override
  List<Object> get props => [uuid];
}

final class LoadPassengerHistoryDetails extends PassengerHistoryInteractionEvent {
  final PassengerHistoryInteractionData historyInteractionData;

  const LoadPassengerHistoryDetails({required this.historyInteractionData});

  @override
  List<Object> get props => [historyInteractionData];
}
