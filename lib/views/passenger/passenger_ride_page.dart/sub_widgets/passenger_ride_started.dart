import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/views/passenger/passenger_chat/component_widgets/passenger_chat_interaction.dart';

import '../../../../bloc/passenger_ride_status/passenger_ride_status_bloc.dart';

class PassengerRideStartedWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PassengerRideStartedWidget();
}

class _PassengerRideStartedWidget extends State<PassengerRideStartedWidget> {
  //getCarDetails
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

  void startChat(String rideId, String driverId, String passengerId, {required onErrorOccured, required onStartChat}) async {
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
    PassengerRideStarted passengerRideStartedState = context.watch<PassengerRideStatusBloc>().state as PassengerRideStarted;

    // TODO: implement build
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            FutureBuilder(
                future: getCarDetails(passengerRideStartedState.rideInformation.driverId),
                builder: (buildContext, snapshot) {
                  if (snapshot.hasData) {
                    print("IS IT WORKING: ${snapshot.data!["vehicle_image_url"]}");
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
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chat room has been started. Please see the chat page to interact.")));
                                      }),
                                      icon: const Icon(
                                        Icons.chat,
                                      ),
                                    ),
                                    IconButton.filled(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.phone,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 5, bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () {
                            context.read<PassengerRideStatusBloc>().add(PassengerRideProgress(rideInformation: passengerRideStartedState.rideInformation));
                          },
                          child: const Text("Confirm")),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ));
  }
}
