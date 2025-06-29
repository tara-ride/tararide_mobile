import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:tararide_mobile/models/history_interaction_data.dart';

abstract class PassengerHistoryInteractionRepository {
  Stream<List<PassengerHistoryInteractionData>> getPassengerHistoryInteractionDataListStream(String businessRole, String uuid);
  Stream<PassengerHistoryInteractionData> getPassengerHistoryInteractionDataById(String historyId);
}

class PassengerHistoryInteractionRepositoryImplementation extends PassengerHistoryInteractionRepository {
  @override
  Stream<List<PassengerHistoryInteractionData>> getPassengerHistoryInteractionDataListStream(String businessRole, String uuid) {
    String fieldName = "";
    if (businessRole == "passenger") {
      fieldName = "passenger_id";
      print("fieldName is: $fieldName dugg");
    }
    if (businessRole == "driver") {
      fieldName = "driver_id";
      print("fieldName is: $fieldName duuhh");
    }

    Stream<QuerySnapshot<Map<String, dynamic>>> firebaseSnaps = FirebaseFirestore.instance.collection("ride_history_information").where("passenger_id", isEqualTo: uuid).snapshots();
    return firebaseSnaps.map((snapshots) {
      return snapshots.docs.map((deployments) {
        return PassengerHistoryInteractionData.fromJson(deployments.data());
      }).toList();
    });
  }

  @override
  Stream<PassengerHistoryInteractionData> getPassengerHistoryInteractionDataById(String historyId) async* {
    Stream<DocumentSnapshot<Object?>> firebaseSnaps = FirebaseFirestore.instance.collection("history_information").doc(historyId).snapshots();

    await for (DocumentSnapshot<Object?> historyInteractionDataDocumentSnapshot in firebaseSnaps) {
      if (historyInteractionDataDocumentSnapshot.exists && historyInteractionDataDocumentSnapshot.data() != null) {
        var snapshotData = historyInteractionDataDocumentSnapshot.data()!;
        print("HOMAY NEEH ${snapshotData}");

        yield PassengerHistoryInteractionData.fromJson(historyInteractionDataDocumentSnapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('PassengerHistory information not found for id: $historyId');
      }
      //
    }
  }
}
