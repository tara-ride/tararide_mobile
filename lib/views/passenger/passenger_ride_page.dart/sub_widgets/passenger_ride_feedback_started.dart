import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tararide_mobile/bloc/passenger_ride_status/passenger_ride_status_bloc.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';

class PassengerRideFeedbackStartedWidget extends StatefulWidget {
  final RideInformationModel rideInformation;

  const PassengerRideFeedbackStartedWidget({super.key, required this.rideInformation});

  @override
  State<StatefulWidget> createState() => PassengerRideFeedbackStartedState();
}

class PassengerRideFeedbackStartedState extends State<PassengerRideFeedbackStartedWidget> {
  double feedback_rating = 0;
  final TextEditingController _feedbackCommentController = TextEditingController();

  Future<String> getVehicleModel(String driverId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    var documentReference = firebaseFirestore.collection("contact_information").doc(driverId);
    var documentData = await documentReference.get();

    if (documentData.exists) {
      return documentData.data()!["vehicle_model"].toString();
    }
    return "";
  }

  Future<String> getPlateNumber(String driverId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    var documentReference = firebaseFirestore.collection("contact_information").doc(driverId);
    var documentData = await documentReference.get();

    if (documentData.exists) {
      return documentData.data()!["plate_number"].toString();
    }
    return "";
  }

  Future<String> getProfilePicURL(String driverId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    var documentReference = firebaseFirestore.collection("personal_information").doc(driverId);
    var documentData = await documentReference.get();

    if (documentData.exists) {
      return documentData.data()!["profilePicImage"].toString();
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    PassengerRideFeedbackStarted passengerRideFeedbackStarted = context.watch<PassengerRideStatusBloc>().state as PassengerRideFeedbackStarted;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Text(
              "Rate your driver",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(blurRadius: 8, blurStyle: BlurStyle.outer, color: Colors.black, offset: Offset(0, 0), spreadRadius: 0),
                ],
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/New-York-City-Backgrounds-HD.jpg"),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: double.infinity,
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [
                        0.0,
                        1.0
                      ], colors: [
                        Color.fromARGB(255, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0),
                      ]),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              child: FutureBuilder(
                                  future: getProfilePicURL(passengerRideFeedbackStarted.rideInformation.driverId),
                                  builder: (itemContext, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: Image.network(snapshot.data!).image,
                                            fit: BoxFit.cover,
                                          ),
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  })),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            child: Container(
                              height: 60,
                              width: 200,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    passengerRideFeedbackStarted.rideInformation.driverName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  FutureBuilder(
                                      future: getVehicleModel(passengerRideFeedbackStarted.rideInformation.driverId),
                                      builder: (buildContext, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "Owner of ${snapshot.data!}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                  FutureBuilder(
                                      future: getPlateNumber(passengerRideFeedbackStarted.rideInformation.driverId),
                                      builder: (buildContext, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "Plate No.: ${snapshot.data!}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(
              "How was your ride?",
              style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: AnimatedRatingStars(
              onChanged: (rating) {
                feedback_rating = rating;
                setState(() {});
              },
              customFilledIcon: Icons.star,
              customHalfFilledIcon: Icons.star_half,
              customEmptyIcon: Icons.star_border,
              starSize: 30,
              animationDuration: const Duration(milliseconds: 50),
              animationCurve: Curves.easeInOutCirc,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Leave a comment",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: TextField(
                  controller: _feedbackCommentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Please type your comment here",
                    hintStyle: TextStyle(fontSize: 12),
                  ),
                  maxLines: 9,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                        FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

                        if (firebaseAuth.currentUser != null) {
                          var accountReference = firebaseFirestore.collection("account_information").doc(firebaseAuth.currentUser!.uid);
                          await accountReference.update({
                            "status": "idle",
                          });

                          var feedbackReference = firebaseFirestore.collection("feedback_information").doc();
                          await feedbackReference.set({
                            "passenger_id": firebaseAuth.currentUser!.uid,
                            "feedback_rating": feedback_rating,
                            "feedback_comment": _feedbackCommentController.text,
                            "feedback_submitted_on": DateTime.now(),
                            "ride_id": passengerRideFeedbackStarted.rideInformation.rideId,
                            "feedback_id": feedbackReference.id,
                          });

                          // var rideInformationReference = firebaseFirestore.collection("ride_information").doc(widget.rideInformation.rideId);

                          // var index = widget.rideInformation.passengersList.indexWhere((item) {
                          //   return item.passengerId == firebaseAuth.currentUser!.uid;
                          // });

                          // widget.rideInformation.passengersList[index].rideStatus = "completed";

                          // await rideInformationReference.update({
                          //   "passengers_list": widget.rideInformation.passengersList,
                          // });
                        }
                        context.read<PassengerRideStatusBloc>().add(PassengerRideFeedbackComplete());
                        // ignore: empty_catches
                      } catch (error) {
                        print(error.toString());
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(error.toString()),
                          duration: const Duration(milliseconds: 200),
                        ));
                      }
                    },
                    child: const Text(
                      "Submit Feedback",
                    ))),
          ),
        ],
      ),
    );
  }
}
