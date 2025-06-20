part of 'chat_interaction_bloc.dart';

sealed class ChatInteractionState extends Equatable {
  const ChatInteractionState();

  @override
  List<Object> get props => [];
}

final class ChatInteractionDefaultState extends ChatInteractionState {
  @override
  List<Object> get props => [];
}

final class ChatInteractionError extends ChatInteractionState {
  @override
  List<Object> get props => [];
}

final class ChatInteractionListLoaded extends ChatInteractionState {
  final List<ChatInteractionData> chatInformationList;

  const ChatInteractionListLoaded({required this.chatInformationList});
  @override
  List<Object> get props => [chatInformationList];
}

final class ChatInteractionInitialized extends ChatInteractionState {
  final ChatInteractionData chatInteraction;

  const ChatInteractionInitialized({required this.chatInteraction});

  @override
  List<Object> get props => [chatInteraction];
}
