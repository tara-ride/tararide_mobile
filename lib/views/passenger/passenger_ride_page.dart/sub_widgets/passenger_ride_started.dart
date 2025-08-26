import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';
import 'package:tararide_mobile/views/passenger/passenger_chat/component_widgets/passenger_chat_interaction.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../bloc/passenger_ride_status/passenger_ride_status_bloc.dart';

class PassengerRideStartedWidget extends StatefulWidget {
  final ValueChanged<String> onRideCancelled;
  const PassengerRideStartedWidget({super.key, required this.onRideCancelled});

  @override
  State<StatefulWidget> createState() => _PassengerRideStartedWidgetState();
}

class _PassengerRideStartedWidgetState extends State<PassengerRideStartedWidget> {
  Future<Map<String, String>> getCarDetails(String driverId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    var contactInfoDocument = await firebaseFirestore.collection("contact_information").doc(driverId).get();
    if (contactInfoDocument.exists) {
      return {
        "plate_number": contactInfoDocument.data()!["plate_number"],
        "vehicle_model": contactInfoDocument.data()!["vehicle_model"],
        "plate_image_url": contactInfoDocument.data()!["plate_image_url"],
        "vehicle_image_url": contactInfoDocument.data()!["vehicle_image_url"],
        "uuid": contactInfoDocument.data()!["uuid"],
      };
    } else {
      return {};
    }
  }

  int getOccupiedSeats(List<PassengersList> passengersList) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      for (var passenger in passengersList) {
        if (passenger.passengerId == firebaseUser.uid) {
          return passenger.seatsOccupied;
        }
      }
    }
    return 0;
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }

  void startChat(String rideId, String driverId, String passengerId, {required onErrorOccured, required onStartChat}) async {
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
      return currentUser!.uid;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    PassengerRideStarted passengerRideStartedState = context.watch<PassengerRideStatusBloc>().state as PassengerRideStarted;

    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            FutureBuilder(
                future: getCarDetails(passengerRideStartedState.rideInformation.driverId),
                builder: (buildContext, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: 150,
                      width: 150,
                      child: Center(
                        child: Container(
                          height: 145,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 0.5,
                                spreadRadius: 1,
                              ),
                            ],
                            image: DecorationImage(
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                snapshot.data!["vehicle_image_url"]!,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Lottie.asset(
                      'assets/sedan_car_driving.json',
                      width: 150,
                      height: 150,
                    );
                  }
                }),
            Expanded(
                child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Your driver is on the way", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Driver: ${passengerRideStartedState.rideInformation.driverName}"),
                  FutureBuilder(
                      future: getCarDetails(passengerRideStartedState.rideInformation.driverId),
                      builder: (buildContext, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Car: ${snapshot.data!["vehicle_model"]}"),
                              Text("Plate Number: ${snapshot.data!["plate_number"]}"),
                            ],
                          );
                        } else {
                          return const Column(
                            children: [
                              Text("Car: N/A"),
                              Text("Plate Number: N/A"),
                            ],
                          );
                        }
                      }),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: FutureBuilder(
                          future: getPassengerId(),
                          builder: (buildContext, snapshot) {
                            if (snapshot.hasData) {
                              return SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton.filled(
                                      onPressed: () => startChat(passengerRideStartedState.rideInformation.rideId, passengerRideStartedState.rideInformation.driverId, snapshot.data!, onErrorOccured: (String error) {}, onStartChat: (String chatId) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text("Chat room has been started. Please see the chat page to interact. $chatId"),
                                          duration: const Duration(milliseconds: 100),
                                        ));
                                      }),
                                      icon: const Icon(
                                        Icons.chat,
                                      ),
                                    ),
                                    IconButton.filled(
                                      onPressed: () async {},
                                      icon: const Icon(
                                        Icons.phone,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 5, bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () async {
                          try {
                            FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                            FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

                            if (firebaseAuth.currentUser != null) {
                              await firebaseFirestore.collection("account_information").doc(firebaseAuth.currentUser!.uid).update({
                                "status": "idle",
                                "ride_id": "",
                              });

                              await firebaseFirestore.collection("ride_information").doc(passengerRideStartedState.rideInformation.rideId).update({
                                "available_seats": FieldValue.increment(getOccupiedSeats(passengerRideStartedState.rideInformation.passengersList)),
                              });
                            }

                            // // List<PassengersList> passengersToBeDeleted = [];
                            // List<Map<String, dynamic>> testList = [];

                            // for (int i = 0; i < passengerRideStartedState.rideInformation.passengersList.length; i++) {
                            //   PassengersList passengerData = passengerRideStartedState.rideInformation.passengersList[i];

                            //   testList.add({
                            //     "estimated_fare": passengerData.estimatedFare,
                            //     "passenger_current_location": GeoPoint(passengerData.passengerCurrentLocation.latitude, passengerData.passengerCurrentLocation.longitude),
                            //     "passenger_destination": GeoPoint(passengerData.passengerDestination.latitude, passengerData.passengerDestination.longitude),
                            //     "passenger_destination_name": passengerData.passengerDestinationName,
                            //     "passenger_email": passengerData.passengerEmail,
                            //     "passenger_id": passengerData.passengerId,
                            //     "passenger_source_location_name": passengerData.passengerSourceLocationName,
                            //     "passenger_source_location": GeoPoint(passengerData.passengerSourceLocation.latitude, passengerData.passengerSourceLocation.longitude),
                            //     "ride_completed_at": passengerData.rideCompletedAt,
                            //     "ride_distance": passengerData.rideDistance,
                            //     "ride_duration": passengerData.rideDuration,
                            //     "ride_started_at": passengerData.rideStartedAt,
                            //     "seats_occupied": passengerData.seatsOccupied,
                            //     "ride_status": passengerData.rideStatus,
                            //   });
                            // }

                            // testList.removeWhere((item) => item["passenger_id"].toString() == firebaseAuth.currentUser!.uid);
                            // //  print("unit test: ${passengersToBeDeleted.toString()} ${passengersToBeDeleted.length}");
                            // await firebaseFirestore.collection("ride_information").doc(passengerRideStartedState.rideInformation.rideId).update(
                            //   {
                            //     "passengers_list": testList,
                            //   },
                            // );
                            if (firebaseAuth.currentUser != null && passengerRideStartedState.rideInformation.passengersList.isNotEmpty) {
                              int index = 0;
                              index = passengerRideStartedState.rideInformation.passengersList.indexWhere((item) {
                                return item.passengerId == firebaseAuth.currentUser!.uid;
                              });

                              passengerRideStartedState.rideInformation.passengersList[index].rideStatus = "cancelled";
                            }
                            List<Map<String, dynamic>> passengerRideUpdateList = [];
                            for (int i = 0; i < passengerRideStartedState.rideInformation.passengersList.length; i++) {
                              PassengersList passengerData = passengerRideStartedState.rideInformation.passengersList[i];

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
                            await firebaseFirestore.collection("ride_information").doc(passengerRideStartedState.rideInformation.rideId).update({
                              "passengers_list": passengerRideUpdateList,
                            });
                            await firebaseFirestore.collection("account_information").doc(firebaseAuth.currentUser!.uid).update({
                              "ride_id": "",
                              "status": "idle",
                            });
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("You have cancelled the ride successfully."),
                              duration: Duration(milliseconds: 300),
                            ));
                            //context.read<PassengerRideStatusBloc>().add(PassengerRideStart(rideId: rideId));
                            context.read<PassengerRideStatusBloc>().add(PassengerRideStatusInitialize());
                            context.read<PassengerRideStatusBloc>().add(PassengerRideStatusInitialize());
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Cannot cancel ride: $error"),
                              duration: const Duration(milliseconds: 3300),
                            ));
                          }
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ));
  }
}
