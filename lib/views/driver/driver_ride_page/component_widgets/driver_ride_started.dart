import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/chat_interaction/chat_interaction_bloc.dart';
import 'package:tararide_mobile/bloc/driver_ride_status/driver_ride_status_bloc.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';
import 'package:tararide_mobile/repository/gcp_distance_matrix_repository.dart';

import '../../../../config/firebase_options.dart';
import '../../../../models/google_distance_matrix_data.dart' as gcp_distance_matrix_model;

// ignore: must_be_immutable
class DriverRideStartedWidget extends StatefulWidget {
  ValueChanged<Map<String, dynamic>> onUpdateRide;

  DriverRideStartedWidget({super.key, required this.onUpdateRide});

  @override
  State<StatefulWidget> createState() => _DriverRideStartedState();
}

class _DriverRideStartedState extends State<DriverRideStartedWidget> {
  int selectedItemIndex = 0;
  String bannerMessage = "Passengers will appear here. Please wait";
  // double checkDistanceFromDestination(RideCoordinates driverLocation, RideCoordinates rideDestination) {
  //   GcpDistanceMatrixRepositoryImplementation gcpDistanceMatrixImplem = GcpDistanceMatrixRepositoryImplementation();
  //   return 0;
  // }
  Future<double> checkDistanceFromDestination(LatLng driverLocation, LatLng rideDestination) async {
    GcpDistanceMatrixRepositoryImplementation gcpDistanceMatrixImplem = GcpDistanceMatrixRepositoryImplementation();
    gcp_distance_matrix_model.GcpDistanceMatrixModel gcpDistanceMatrixModel = await gcpDistanceMatrixImplem.getDistanceMatrixDataOnce(SystemConstants().google_cloud_api_key, driverLocation, rideDestination);

    print("HERE YOU GO: ${gcpDistanceMatrixModel.rows[0].elements[0].distance.text}");
    double distanceValue = gcpDistanceMatrixModel.rows[0].elements[0].distance.value.toDouble() * .001;
    return distanceValue;
  }

  Future<void> updateRideDetails(String rideId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    if (firebaseAuth.currentUser != null) {
      await firebaseFirestore.collection("account_information").doc(firebaseAuth.currentUser!.uid).update({
        "ride_id": "",
        "status": "idle",
      });

      await firebaseFirestore.collection("ride_information").doc(rideId).update({
        "status": "completed",
        "ride_end_date": DateTime.now(),
      });
    }
  }

  Future<String> getPassengerName(String passengerId) async {
    String passengerFirstName = "";
    String passengerLastName = "";

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var personalInfo = firebaseFirestore.collection("personal_information").doc(passengerId);

    var personalInfoSnapshot = await personalInfo.get();
    if (personalInfoSnapshot.exists) {
      passengerFirstName = personalInfoSnapshot.data()!["first_name"];
      passengerLastName = personalInfoSnapshot.data()!["last_name"];
    }

    return "$passengerFirstName $passengerLastName";
  }

  Future<String> getProfilePicUrl(String userId) async {
    String profilePicUrl = "";
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var personalInfo = firebaseFirestore.collection("personal_information").doc(userId);

    var personalInfoSnapshot = await personalInfo.get();
    if (personalInfoSnapshot.exists) {
      profilePicUrl = personalInfoSnapshot.data()!["profilePicImage"];
    }
    return profilePicUrl;
  }

  Future<String> getMyId() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var currentUser = firebaseAuth.currentUser;

    if (currentUser != null) {
      return currentUser!.uid;
    } else {
      return "";
    }
  }

  void startChat(String rideId, String passengerId, String driverId, {required onErrorOccured, required onStartChat}) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var chatInfoInstance = firebaseFirestore.collection("chat_information");
    try {
      final QuerySnapshot querySnapshot = await firebaseFirestore
          .collection('chat_information') // Replace with your actual collection name
          .where('driver_id', isEqualTo: driverId)
          .where('passenger_id', isEqualTo: passengerId)
          .get();

      // var docSnapshot = await firebaseFirestore.collection("chat_information").doc('F3TBfzRHRG9CL7Z9KegK').get();

      // if (docSnapshot.exists) {
      //   print("docSNAPSHOT: ${docSnapshot.data()!.toString()}");
      // }

      if (querySnapshot.docs.isNotEmpty) {
        print("querySnapshot.docs.first.id; ${querySnapshot.docs.first.id}");
        onStartChat(querySnapshot.docs.first.id);
      } else {
        var newChatInfoDocument = chatInfoInstance.doc();

        await newChatInfoDocument.set({
          "driver_id": driverId,
          "passenger_id": passengerId,
          "ride_id": rideId,
          "chat_id": newChatInfoDocument.id,
          "chat_created_on": DateTime.now(),
          "chat_interaction": [
            {
              "messaged_by": passengerId,
              "message_text": "Hello!",
              "messaged_on": DateTime.now(),
            },
          ],
        });
        onStartChat(newChatInfoDocument.id);
      }
    } catch (error) {
      onErrorOccured("$error");
    }
  }

  Future<String> getPassengerId() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var currentUser = firebaseAuth.currentUser;

    if (currentUser != null) {
      return currentUser!.uid;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final DriverRidePassengersLoaded driverRidePassengersLoadedState = context.watch<DriverRideStatusBloc>().state as DriverRidePassengersLoaded;

    widget.onUpdateRide({
      "sourceLocation": driverRidePassengersLoadedState.rideInformation.rideSourceLocation,
      "destination": driverRidePassengersLoadedState.rideInformation.rideDestination,
    });
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: double.infinity,
          child: driverRidePassengersLoadedState.rideInformation.passengersList.isNotEmpty
              ? ListView.builder(
                  itemCount: driverRidePassengersLoadedState.rideInformation.passengersList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        right: 5,
                        bottom: 5,
                        left: 5,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          selectedItemIndex = index;
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          height: 50,
                          width: 75,
                          decoration: BoxDecoration(
                            color: selectedItemIndex == index ? const Color.fromARGB(255, 232, 217, 255) : Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(3)),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 0.5,
                                offset: Offset.zero,
                                spreadRadius: 0.5,
                              )
                            ],
                          ),
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 300),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              driverRidePassengersLoadedState.rideInformation.passengersList[index].seatsOccupied > 1 ? const Icon(Icons.people) : const Icon(Icons.person),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                "${driverRidePassengersLoadedState.rideInformation.passengersList[index].seatsOccupied}",
                              )
                            ],
                          )),
                        ),
                      ),
                    );
                  },
                )
              : const SizedBox.shrink(),
        ),
        driverRidePassengersLoadedState.rideInformation.passengersList.isEmpty
            ? Expanded(
                child: SizedBox(
                    child: Column(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            bannerMessage,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )),
                    FutureBuilder(
                        future: checkDistanceFromDestination(
                          LatLng(driverRidePassengersLoadedState.rideInformation.driverCurrentLocation.latitude, driverRidePassengersLoadedState.rideInformation.driverCurrentLocation.longitude),
                          LatLng(driverRidePassengersLoadedState.rideInformation.rideDestination.latitude, driverRidePassengersLoadedState.rideInformation.rideDestination.longitude),
                        ),
                        builder: (destinationContext, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data! > .7) {
                              bannerMessage = "Passengers will appear here, please wait.";

                              return const SizedBox.shrink();
                            } else {
                              bannerMessage = "You have reached your destination";
                              return Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await updateRideDetails(driverRidePassengersLoadedState.rideInformation.rideId).then((onValue) {
                                          context.read<DriverRideStatusBloc>().add(DriverCompleteRide(rideInformation: driverRidePassengersLoadedState.rideInformation));
                                        });
                                      },
                                      child: const Text("Complete Ride"),
                                    ),
                                  )
                                ],
                              );
                            }
                          }
                          return Container();
                        }),
                  ],
                )),
              )
            : Expanded(
                child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Color.fromARGB(88, 0, 0, 0),
                        blurRadius: 2,
                        spreadRadius: 2,
                      )
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                            child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    height: 280,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        color: Colors.white,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Colors.black,
                                            offset: Offset.zero,
                                            blurRadius: 0.5,
                                            spreadRadius: 0.5,
                                          )
                                        ],
                                      ),
                                      child: FutureBuilder(
                                          future: getProfilePicUrl(driverRidePassengersLoadedState.rideInformation.passengersList[selectedItemIndex].passengerId),
                                          builder: (buildContext, snapshot) {
                                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                              return Image(
                                                image: NetworkImage(snapshot.data!),
                                                alignment: Alignment.center,
                                                fit: BoxFit.cover,
                                              );
                                            }
                                            return Container();
                                          }),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          top: 5,
                                          left: 5,
                                          right: 10,
                                        ),
                                      ),
                                      FutureBuilder(
                                          future: getPassengerName(driverRidePassengersLoadedState.rideInformation.passengersList[selectedItemIndex].passengerId),
                                          builder: (buildContext, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!,
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                            return Container();
                                          }),
                                      Text(
                                        driverRidePassengersLoadedState.rideInformation.passengersList[selectedItemIndex].passengerEmail,
                                        style: const TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "ETA: ${driverRidePassengersLoadedState.rideInformation.passengersList[selectedItemIndex].rideDuration}",
                                      ),
                                      Text(
                                        "Seats Occupied: ${driverRidePassengersLoadedState.rideInformation.passengersList[selectedItemIndex].seatsOccupied}",
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          FutureBuilder(
                                            future: getMyId(),
                                            builder: (itemContext, snapshot) {
                                              if (snapshot.hasData) {
                                                return IconButton.filled(
                                                  onPressed: () =>
                                                      startChat(driverRidePassengersLoadedState.rideInformation.rideId, driverRidePassengersLoadedState.rideInformation.passengersList[selectedItemIndex].passengerId, snapshot.data!, onErrorOccured: (String error) {}, onStartChat: (String chatId) {
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                      content: Text("Chat room has been started. Please see the chat page to interact."),
                                                      duration: Duration(
                                                        milliseconds: 100,
                                                      ),
                                                    ));
                                                  }),
                                                  icon: const Icon(
                                                    Icons.chat,
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox.shrink();
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2.5,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_pin),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        driverRidePassengersLoadedState.rideInformation.passengersList[selectedItemIndex].passengerSourceLocationName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2.5,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_city),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        driverRidePassengersLoadedState.rideInformation.passengersList[selectedItemIndex].passengerDestinationName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                      ),
                      SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      style: const ButtonStyle(surfaceTintColor: WidgetStatePropertyAll(Color.fromARGB(255, 161, 2, 2))),
                                      onPressed: () {
                                        // widget.onUpdateRide({
                                        //   "checkDestination": driverRidePassengersLoadedState.rideInformation.rideDestination,
                                        // });
                                      },
                                      child: const Text("Reject"),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        widget.onUpdateRide({
                                          "checkDestination": driverRidePassengersLoadedState.rideInformation.rideDestination,
                                        });
                                      },
                                      child: const Text("Pick Up"),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              )),
      ],
    );
  }
}
