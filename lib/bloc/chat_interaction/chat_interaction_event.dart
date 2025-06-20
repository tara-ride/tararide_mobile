part of 'chat_interaction_bloc.dart';

sealed class ChatInteractionEvent extends Equatable {
  const ChatInteractionEvent();

  @override
  List<Object> get props => [];
}

final class LoadChatInteraction extends ChatInteractionEvent {
  @override
  List<Object> get props => [];
}

final class InitializeChatInteraction extends ChatInteractionEvent {
  final String chatId;

  const InitializeChatInteraction({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

final class ChatInteractionLoadList extends ChatInteractionEvent {
  final List<ChatInteractionData> chatInteractionDataList;

  const ChatInteractionLoadList({required this.chatInteractionDataList});

  @override
  List<Object> get props => [chatInteractionDataList];
}

final class InitializeChatInteractionList extends ChatInteractionEvent {
  final String uuid;

  const InitializeChatInteractionList({required this.uuid, required});

  @override
  List<Object> get props => [uuid];
}

final class LoadChatDetails extends ChatInteractionEvent {
  final ChatInteractionData chatInteractionData;

  const LoadChatDetails({required this.chatInteractionData});

  @override
  List<Object> get props => [chatInteractionData];
}
