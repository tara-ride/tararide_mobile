part of 'passenger_history_interaction_bloc.dart';

sealed class PassengerHistoryInteractionState extends Equatable {
  const PassengerHistoryInteractionState();

  @override
  List<Object> get props => [];
}

final class PassengerHistoryInteractionDefaultState extends PassengerHistoryInteractionState {
  @override
  List<Object> get props => [];
}

final class PassengerHistoryInteractionError extends PassengerHistoryInteractionState {
  @override
  List<Object> get props => [];
}

final class PassengerHistoryInteractionListLoaded extends PassengerHistoryInteractionState {
  final List<PassengerHistoryInteractionData> historyInformationList;

  const PassengerHistoryInteractionListLoaded({required this.historyInformationList});
  @override
  List<Object> get props => [historyInformationList];
}

final class PassengerHistoryInteractionInitialized extends PassengerHistoryInteractionState {
  final PassengerHistoryInteractionData historyInteraction;

  const PassengerHistoryInteractionInitialized({required this.historyInteraction});

  @override
  List<Object> get props => [historyInteraction];
}
