import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tararide_mobile/models/history_interaction_data.dart';
import 'package:tararide_mobile/repository/passenger_history_interaction_repository.dart';

part 'passenger_history_interaction_event.dart';
part 'passenger_history_interaction_state.dart';

class PassengerHistoryInteractionBloc extends Bloc<PassengerHistoryInteractionEvent, PassengerHistoryInteractionState> {
  PassengerHistoryInteractionBloc() : super(PassengerHistoryInteractionDefaultState()) {
    final PassengerHistoryInteractionRepositoryImplementation _historyInteractionRepositoryImplementation = PassengerHistoryInteractionRepositoryImplementation();
    StreamSubscription? _streamSubscription;
    on<PassengerHistoryInteractionEvent>((event, emit) {
      // TODO: implement event handler
    });
    // PassengerHistory Interaction by ID
    on<LoadPassengerHistoryInteraction>((event, emit) async {
      Future.delayed(const Duration(seconds: 1));
      emit(PassengerHistoryInteractionDefaultState());
    });
    // PassengerHistory Interaction List
    on<InitializePassengerHistoryInteractionList>((event, emit) async {
      // list down all history interaction that has the uuid.

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
        _streamSubscription = _historyInteractionRepositoryImplementation.getPassengerHistoryInteractionDataListStream(documentSnapshot.data()!["business_role"].toString(), event.uuid).listen((onValue) {
          print("isittt${onValue.isNotEmpty}");
          add(PassengerHistoryInteractionLoadList(historyInteractionDataList: onValue));
        });
      } else {
        emit(PassengerHistoryInteractionError());
      }
    });

    on<PassengerHistoryInteractionLoadList>((event, emit) {
      emit(PassengerHistoryInteractionListLoaded(historyInformationList: event.historyInteractionDataList));
    });

    on<InitializePassengerHistoryInteraction>((event, emit) {
      emit(PassengerHistoryInteractionInitialized(historyInteraction: event.historyInteractionData));
    });
  }
}
