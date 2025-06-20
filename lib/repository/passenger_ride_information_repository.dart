import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';

abstract class PassengerRideInformationRepository {
  Stream<List<RideInformationModel>> getPassengerRideInformationList();
  Stream<List<RideInformationModel>> getPassengerRideInformationListStream();
  Stream<RideInformationModel> getRideInformationByID(String rideId);
}

class PassengerRideInformationRepositoryImplementation implements PassengerRideInformationRepository {
  @override
  Stream<List<RideInformationModel>> getPassengerRideInformationList() async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference ridesCollection = firestore.collection('ride_information');
    QuerySnapshot querySnapshot = await ridesCollection.get();
    Stream<QuerySnapshot<Object?>> rideInformationDocumentStream = ridesCollection.snapshots();

    if (querySnapshot.docs.isEmpty) {
      print("No ride information found.");
      yield [];
      return;
    }
    print("CONFIRMM ADAF");
    //print("RIDE INFORMATION ${await rideInformationDocumentStream.length}");
    print("Passenger Ride Information List: ${querySnapshot.docs.length}");
    print("Passenger Ride Information List Data: ${querySnapshot.docs[0].data()}");

    List<RideInformationModel> rideInformationList = querySnapshot.docs.map((doc) => RideInformationModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
    if (rideInformationList.isNotEmpty) {
      print("Passenger Ride Information List: ${rideInformationList.length}");
      print("Passenger Ride Information List Data: ${rideInformationList[0].toJson()}");
      yield rideInformationList;
    } else {
      yield [];
    }
  }

  @override
  Stream<List<RideInformationModel>> getPassengerRideInformationListStream() {
    Stream<QuerySnapshot<Map<String, dynamic>>> firebaseSnaps = FirebaseFirestore.instance.collection("ride_information").snapshots();
    return firebaseSnaps.map((snapshots) {
      return snapshots.docs.map((deployments) {
        return RideInformationModel.fromJson(deployments.data());
      }).toList();
    });
  }

  @override
  Stream<RideInformationModel> getRideInformationByID(String rideId) async* {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference rideInformationCollection = firebaseFirestore.collection("ride_information");

    Stream<DocumentSnapshot<Object?>> rideInformationDocumentStream = rideInformationCollection.doc(rideId).snapshots();

    await for (DocumentSnapshot<Object?> rideInformationDocumentSnapshot in rideInformationDocumentStream) {
      if (rideInformationDocumentSnapshot.exists && rideInformationDocumentSnapshot.data() != null) {
        var snapshotData = rideInformationDocumentSnapshot.data()!;
        print("HOMAY NEEH ${snapshotData}");

        yield RideInformationModel.fromJson(rideInformationDocumentSnapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Ride information not found for id: $rideId');
      }
      //
    }
  }
}
