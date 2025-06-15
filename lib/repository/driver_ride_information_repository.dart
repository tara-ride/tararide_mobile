import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';

abstract class DriverRideInformationRepository {
  Stream<RideInformationModel> getRideInformationByID(String rideId);
}

class DriverRideInformationRepositoryImplementation extends DriverRideInformationRepository {
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
