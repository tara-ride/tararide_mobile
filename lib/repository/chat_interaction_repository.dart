import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:tararide_mobile/models/chat_interaction_data.dart';

abstract class ChatInteractionRepository {
  Stream<List<ChatInteractionData>> getChatInteractionDataListStream(String businessRole, String uuid);
  Stream<ChatInteractionData> getChatInteractionDataById(String chatId);
}

class ChatInteractionRepositoryImplementation extends ChatInteractionRepository {
  @override
  Stream<List<ChatInteractionData>> getChatInteractionDataListStream(String businessRole, String uuid) {
    String fieldName = "";
    if (businessRole == "passenger") {
      fieldName = "passenger_id";
    }
    if (businessRole == "driver") {
      fieldName == "driver_id";
    }
    Stream<QuerySnapshot<Map<String, dynamic>>> firebaseSnaps = FirebaseFirestore.instance.collection("chat_information").where(fieldName, isEqualTo: uuid).snapshots();
    return firebaseSnaps.map((snapshots) {
      return snapshots.docs.map((deployments) {
        return ChatInteractionData.fromJson(deployments.data());
      }).toList();
    });
  }

  @override
  Stream<ChatInteractionData> getChatInteractionDataById(String chatId) async* {
    Stream<DocumentSnapshot<Object?>> firebaseSnaps = FirebaseFirestore.instance.collection("chat_information").doc(chatId).snapshots();

    await for (DocumentSnapshot<Object?> chatInteractionDataDocumentSnapshot in firebaseSnaps) {
      if (chatInteractionDataDocumentSnapshot.exists && chatInteractionDataDocumentSnapshot.data() != null) {
        var snapshotData = chatInteractionDataDocumentSnapshot.data()!;
        print("HOMAY NEEH ${snapshotData}");

        yield ChatInteractionData.fromJson(chatInteractionDataDocumentSnapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Chat information not found for id: $chatId');
      }
      //
    }
  }
}
