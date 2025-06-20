import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tararide_mobile/models/chat_interaction_data.dart';
import 'package:tararide_mobile/repository/chat_interaction_repository.dart';

part 'chat_interaction_event.dart';
part 'chat_interaction_state.dart';

class ChatInteractionBloc extends Bloc<ChatInteractionEvent, ChatInteractionState> {
  ChatInteractionRepositoryImplementation _chatInteractionRepositoryImplementation = ChatInteractionRepositoryImplementation();
  StreamSubscription? _streamSubscription;
  //Chat Interaction Constructor.
  ChatInteractionBloc() : super(ChatInteractionDefaultState()) {
    // Chat Interaction by ID
    on<LoadChatInteraction>((event, emit) async {
      Future.delayed(const Duration(seconds: 1));
      emit(ChatInteractionDefaultState());
    });
    // Chat Interaction List
    on<InitializeChatInteractionList>((event, emit) async {
      // list down all chat interaction that has the uuid.

      if (_streamSubscription != null) {
        _streamSubscription!.cancel();
      }
      // Determine business role
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      DocumentReference<Map<String, dynamic>> docRef = firebaseFirestore.collection("account_information").doc(event.uuid);

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await docRef.get();
      if (documentSnapshot.exists) {
        print("THE BUSINESS ROOLE: ${documentSnapshot.data()!["business_role"]}");
        print("THE UUID: ${event.uuid}");
        _streamSubscription = _chatInteractionRepositoryImplementation.getChatInteractionDataListStream(documentSnapshot.data()!["business_role"], event.uuid).listen((onValue) {
          print("${onValue.isNotEmpty}");
          add(ChatInteractionLoadList(chatInteractionDataList: onValue));
        });
      } else {
        emit(ChatInteractionError());
      }
    });

    on<ChatInteractionLoadList>((event, emit) {
      emit(ChatInteractionListLoaded(chatInformationList: event.chatInteractionDataList));
    });

    on<InitializeChatInteraction>((event, emit) {
      if (_streamSubscription != null) {
        _streamSubscription!.cancel();
      }

      print("${event.chatId}");
      _streamSubscription = _chatInteractionRepositoryImplementation.getChatInteractionDataById(event.chatId).listen((onValue) {
        add(LoadChatDetails(chatInteractionData: onValue));
      });
    });

    on<LoadChatDetails>((event, emit) {
      emit(ChatInteractionInitialized(chatInteraction: event.chatInteractionData));
    });
  }
}
