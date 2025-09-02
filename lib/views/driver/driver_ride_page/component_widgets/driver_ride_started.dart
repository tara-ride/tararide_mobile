// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/driver_ride_status/driver_ride_status_bloc.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';
import 'package:tararide_mobile/repository/gcp_distance_matrix_repository.dart';

import '../../../../config/firebase_options.dart';
import '../../../../models/google_distance_matrix_data.dart' as gcp_distance_matrix_model;

final class DriverRideStartedWidget extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onUpdateRide;

  const DriverRideStartedWidget({super.key, required this.onUpdateRide});

  @override
  State<StatefulWidget> createState() => _DriverRideStartedState();
}

class _DriverRideStartedState extends State<DriverRideStartedWidget> {
  int selectedItemIndex = 0;
  String bannerMessage = "Passengers will appear here, please wait";

  Future<double> checkDistanceFromDestination(LatLng driverLocation, LatLng rideDestination) async {
    GcpDistanceMatrixRepositoryImplementation gcpDistanceMatrixImplem = GcpDistanceMatrixRepositoryImplementation();
    gcp_distance_matrix_model.GcpDistanceMatrixModel gcpDistanceMatrixModel = await gcpDistanceMatrixImplem.getDistanceMatrixDataOnce(SystemConstants().google_cloud_api_key, driverLocation, rideDestination);

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
      return currentUser.uid;
    } else {
      return "";
    }
  }

  void startChat(String rideId, String passengerId, String driverId, {required onErrorOccured, required onStartChat}) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var chatInfoInstance = firebaseFirestore.collection("chat_information");
    try {
      final QuerySnapshot querySnapshot = await firebaseFirestore.collection('chat_information').where('driver_id', isEqualTo: driverId).where('passenger_id', isEqualTo: passengerId).get();

      if (querySnapshot.docs.isNotEmpty) {
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
      return currentUser.uid;
    } else {
      return "";
    }
  }

  Future<bool> sendNotification(String recipientUserId, String messageTitle, String messageBody) async {
    try {
      // Get a reference to your Cloud Function
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendNotification');

      // Call the function with the recipient's user ID
      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'recipientId': recipientUserId,
        'messageTitle': messageTitle,
        'messageBody': messageBody,
      });
      return result.data['success'] as bool;
    } on FirebaseFunctionsException catch (e) {
      print('Failed to call Cloud Function: ${e.code} - ${e.message}');
      throw Exception('Failed to call Cloud Function: ${e.message}');
    } catch (e) {
      print('Failed to call Cloud Function: ${e} - ${e}');
      throw Exception('Failed to call Cloud Function: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final DriverRidePassengersLoaded driverRidePassengersLoadedState = context.watch<DriverRideStatusBloc>().state as DriverRidePassengersLoaded;

    List<PassengersList> filteredPassengersList = driverRidePassengersLoadedState.rideInformation.passengersList.where((passenger) => passenger.rideStatus != "cancelled").where((passenger) => passenger.rideStatus != "completed").toList();
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: double.infinity,
          child: filteredPassengersList.isNotEmpty
              ? ListView.builder(
                  itemCount: filteredPassengersList.length,
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
                              filteredPassengersList[index].seatsOccupied > 1 ? const Icon(Icons.people) : const Icon(Icons.person),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                "${filteredPassengersList[index].seatsOccupied}",
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
        filteredPassengersList.isEmpty
            ? Expanded(
                child: SizedBox(
                    child: Column(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          "assets/passenger_waiting.json",
                          width: 200,
                          height: 200,
                        ),
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
                                            future: getProfilePicUrl(filteredPassengersList[selectedItemIndex].passengerId),
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
                                            future: getPassengerName(filteredPassengersList[selectedItemIndex].passengerId),
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
                                          filteredPassengersList[selectedItemIndex].passengerEmail,
                                          style: const TextStyle(
                                            fontSize: 11,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "ETA: ${filteredPassengersList[selectedItemIndex].rideDuration}",
                                        ),
                                        Text(
                                          "Seats Occupied: ${filteredPassengersList[selectedItemIndex].seatsOccupied}",
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            FutureBuilder(
                                              future: getMyId(),
                                              builder: (itemContext, snapshot) {
                                                if (snapshot.hasData) {
                                                  return IconButton.filled(
                                                    onPressed: () => startChat(driverRidePassengersLoadedState.rideInformation.rideId, filteredPassengersList[selectedItemIndex].passengerId, snapshot.data!, onErrorOccured: (String error) {}, onStartChat: (String chatId) {
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
                                          filteredPassengersList[selectedItemIndex].passengerSourceLocationName,
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
                                          filteredPassengersList[selectedItemIndex].passengerDestinationName,
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
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: filteredPassengersList[selectedItemIndex].rideStatus == "waiting"
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton(
                                          style: const ButtonStyle(surfaceTintColor: WidgetStatePropertyAll(Color.fromARGB(255, 161, 2, 2))),
                                          onPressed: () async {
                                            selectedItemIndex = 0;
                                            widget.onUpdateRide({
                                              "checkDestination": filteredPassengersList[selectedItemIndex].passengerDestination,
                                            });

                                            try {
                                              FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                                              FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

                                              if (firebaseAuth.currentUser != null && filteredPassengersList.isNotEmpty) {
                                                int index = 0;
                                                index = filteredPassengersList.indexWhere((item) {
                                                  return item.passengerId == filteredPassengersList[selectedItemIndex].passengerId;
                                                });

                                                filteredPassengersList[index].rideStatus = "cancelled";
                                              }
                                              List<Map<String, dynamic>> passengerRideUpdateList = [];
                                              for (int i = 0; i < filteredPassengersList.length; i++) {
                                                PassengersList passengerData = filteredPassengersList[i];

                                                passengerRideUpdateList.add(
                                                  {
                                                    "estimated_fare": passengerData.estimatedFare,
                                                    "passenger_current_location": GeoPoint(passengerData.passengerCurrentLocation.latitude, passengerData.passengerCurrentLocation.longitude),
                                                    "passenger_destination": GeoPoint(passengerData.passengerDestination.latitude, passengerData.passengerDestination.longitude),
                                                    "passenger_destination_name": passengerData.passengerDestinationName,
                                                    "passenger_email": passengerData.passengerEmail,
                                                    "passenger_id": passengerData.passengerId,
                                                    "passenger_source_location_name": passengerData.passengerSourceLocationName,
                                                    "passenger_source_location": GeoPoint(passengerData.passengerSourceLocation.latitude, passengerData.passengerSourceLocation.longitude),
                                                    "ride_duration": passengerData.rideDuration,
                                                    "ride_started_at": passengerData.rideStartedAt,
                                                    "ride_distance": passengerData.rideDistance,
                                                    "seats_occupied": passengerData.seatsOccupied,
                                                    "ride_status": passengerData.rideStatus,
                                                    "ride_completed_at": passengerData.rideCompletedAt,
                                                    "status": passengerData.rideStatus,
                                                  },
                                                );
                                              }
                                              await firebaseFirestore.collection("ride_information").doc(driverRidePassengersLoadedState.rideInformation.rideId).update({
                                                "available_seats": driverRidePassengersLoadedState.rideInformation.availableSeats + filteredPassengersList[selectedItemIndex].seatsOccupied,
                                                "passengers_list": passengerRideUpdateList,
                                              });
                                              await firebaseFirestore.collection("account_information").doc(filteredPassengersList[selectedItemIndex].passengerId).update({
                                                "ride_id": "",
                                                "status": "idle",
                                              });
                                              await sendNotification(filteredPassengersList[selectedItemIndex].passengerId, "Your ride is cancelled.", "Please request a new ride.");
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text("Ride has been rejected."),
                                                  duration: Duration(milliseconds: 1000),
                                                ),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Ride cannot be rejected. $e"),
                                                  duration: const Duration(milliseconds: 500),
                                                ),
                                              );
                                            }
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
                                          onPressed: () async {
                                            widget.onUpdateRide({
                                              "checkDestination": driverRidePassengersLoadedState.rideInformation.rideDestination,
                                            });
                                            try {
                                              FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                                              FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

                                              if (firebaseAuth.currentUser != null && filteredPassengersList.isNotEmpty) {
                                                int index = 0;
                                                index = filteredPassengersList.indexWhere((item) {
                                                  return item.passengerId == filteredPassengersList[selectedItemIndex].passengerId;
                                                });

                                                filteredPassengersList[index].rideStatus = "in_a_ride";
                                              }
                                              List<Map<String, dynamic>> passengerRideUpdateList = [];
                                              for (int i = 0; i < driverRidePassengersLoadedState.rideInformation.passengersList.length; i++) {
                                                PassengersList passengerData = driverRidePassengersLoadedState.rideInformation.passengersList[i];

                                                passengerRideUpdateList.add({
                                                  "estimated_fare": passengerData.estimatedFare,
                                                  "passenger_current_location": GeoPoint(passengerData.passengerCurrentLocation.latitude, passengerData.passengerCurrentLocation.longitude),
                                                  "passenger_destination": GeoPoint(passengerData.passengerDestination.latitude, passengerData.passengerDestination.longitude),
                                                  "passenger_destination_name": passengerData.passengerDestinationName,
                                                  "passenger_email": passengerData.passengerEmail,
                                                  "passenger_id": passengerData.passengerId,
                                                  "passenger_source_location_name": passengerData.passengerSourceLocationName,
                                                  "passenger_source_location": GeoPoint(passengerData.passengerSourceLocation.latitude, passengerData.passengerSourceLocation.longitude),
                                                  "ride_duration": passengerData.rideDuration,
                                                  "ride_started_at": passengerData.rideStartedAt,
                                                  "ride_distance": passengerData.rideDistance,
                                                  "seats_occupied": passengerData.seatsOccupied,
                                                  "ride_status": passengerData.rideStatus,
                                                  "ride_completed_at": passengerData.rideCompletedAt,
                                                });
                                              }
                                              await firebaseFirestore.collection("ride_information").doc(driverRidePassengersLoadedState.rideInformation.rideId).update({
                                                "passengers_list": passengerRideUpdateList,
                                              });

                                              await firebaseFirestore.collection("account_information").doc(driverRidePassengersLoadedState.rideInformation.passengersList[selectedItemIndex].passengerId).update({
                                                "status": "in_a_ride",
                                              });
                                              await sendNotification(filteredPassengersList[selectedItemIndex].passengerId, "Your driver is on the way!", "Please wait for the driver to arrive at your location.");

                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                content: Text("On the way to pick up the passenger."),
                                                duration: Duration(milliseconds: 300),
                                              ));
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text("Cannot pick up the passenger. $e"),
                                                duration: const Duration(milliseconds: 500),
                                              ));
                                            }
                                          },
                                          child: const Text("Pick Up"),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : const Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text("Currently in a ride"),
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }
}
